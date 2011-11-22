
def judge
  compiler = Compiler.for Source.type

  runner, success = compiler.compile Source.path
  return :compilation_error if not success
  
  # avaliable comparers
  #comparer = DoubleComparer.new 0.00001 (soon)
  #comparer = StringComparer.new :ignore_whitespace => true (soon)
  comparer = IntComparer.new
  
  for input_file in Dir[Paths.PackageRoot + "*.in"]
#    logger.info "== #{input_file} =="
    # 1.in -> 1.out
    original_out = input_file.clone
    original_out[".in"] = ".out"
    
    # create new temp file for output
    out_file = Files.new_temp
    

    tle, mle, segv = runner.run input_file, out_file
    return :time_limit_exceeded if tle
    return :memory_limit_exceeded if mle
    return :runtime_error if segv

    success = comparer.compare out_file, original_out
    return :wrong_answer if not success
    # uncomment this to remove temp files
  end
  return :accept
end
