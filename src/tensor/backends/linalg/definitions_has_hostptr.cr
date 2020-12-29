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

module Num::Backend::LinalgHasHostptr(T)
  def blas_scale!(a : Number)
    blas_call(scal, @size, T.new(a), self.to_hostptr, @strides[0])
  end

  def blas_swap(other : Num::Backend::LinalgHasHostptr(T))
    blas_call(swap, @size, self.to_hostptr, 1, other.to_hostptr, 1)
  end

  def blas_copy(other : Num::Backend::LinalgHasHostptr(T))
    blas_call(copy, @size, self.to_hostptr, 1, other.to_hostptr, 1)
  end

  def blas_dot(other : Num::Backend::LinalgHasHostptr(T))
    blas_call(dot, @size, self.to_hostptr, @strides[0], other.to_hostptr, other.strides[0])
  end
end
