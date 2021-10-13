# Copyright (c) 2020 Crystal Data Contributors
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

class Num::NN::SigmoidCrossEntropy(T) < Num::Grad::Gate(T)
  getter target : T
  getter cache : Num::Grad::Variable(T)

  def initialize(@target : T, @cache : Num::Grad::Variable(T))
  end

  def backward(payload : Num::Grad::Payload(T)) : Array(T)
    gradient = payload.variable.grad
    Num::NN.sigmoid_cross_entropy_backwards(gradient, cache.value, target)
  end

  def cache(result : Num::Grad::Variable, *args)
    a, target = args

    result.grad = T.zeros_like(result.value)
    result.requires_grad = true

    Num::Grad.register("SigmoidCrossEntropy", self, result, a)
  end
end
