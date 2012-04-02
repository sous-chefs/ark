Feature: ark dump
  
Scenario: File should be in its proper place
  When I run `ls /usr/local/foobar/`
  Then the output should match /jaxrpc.jar/
