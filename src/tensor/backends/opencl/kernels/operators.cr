# Copyright (c) 2021 Crystal Data Contributors
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

class Num::ArithmeticKernel(T) < Num::Kernel(T)
  @@operator : String = ""
  @@name : String = ""

  def get_program(dtype)
    "
    #{super}

    #pragma OPENCL EXTENSION cl_khr_fp64 : enable

    __kernel void #{@@name}
                (const int rank,
                const int len,
                __global const int * restrict dst_shape,
                __global const int * restrict dst_strides,
                const int dst_offset,
                __global       #{dtype} * restrict const dst_data,
                __global const int * restrict A_shape,
                __global const int * restrict A_strides,
                const int A_offset,
                __global const #{dtype} * restrict const A_data,
                __global const int * restrict B_shape,
                __global const int * restrict B_strides,
                const int B_offset,
                __global const #{dtype} * restrict const B_data)
    {
      for (int elemID = get_global_id(0);
      elemID < len;
      elemID += get_global_size(0)) {
        const int dst_real_idx = opencl_getIndexOfElementID(rank, dst_shape, dst_strides, dst_offset, elemID);
        const int A_real_idx = opencl_getIndexOfElementID(rank, A_shape, A_strides, A_offset, elemID);
        const int B_real_idx = opencl_getIndexOfElementID(rank, B_shape, B_strides, B_offset, elemID);
        dst_data[dst_real_idx] = A_data[A_real_idx] #{@@operator} B_data[B_real_idx];
      }
    }
    "
  end

  def call(a : Tensor(T, OCL(T)), b : Tensor(T, OCL(T)))
    a, b = a.broadcast(b)
    result = Tensor(T, OCL(T)).new(a.shape)
    Cl.args(
      @kernel,
      result.rank,
      result.size,
      result.data.shape,
      result.data.strides,
      result.offset,
      result.to_unsafe,
      a.data.shape,
      a.data.strides,
      a.offset,
      a.to_unsafe,
      b.data.shape,
      b.data.strides,
      b.offset,
      b.to_unsafe
    )
    Cl.run(Num::ClContext.instance.queue, @kernel, result.size)
    result
  end
end

class Num::AddKernel(T) < Num::ArithmeticKernel(T)
  @@operator : String = "+"
  @@name : String = "addKernel"
end

class Num::SubtractKernel(T) < Num::ArithmeticKernel(T)
  @@operator : String = "-"
  @@name : String = "subtractKernel"
end

class Num::MultiplyKernel(T) < Num::ArithmeticKernel(T)
  @@operator : String = "*"
  @@name : String = "multiplyKernel"
end

class Num::DivideKernel(T) < Num::ArithmeticKernel(T)
  @@operator : String = "/"
  @@name : String = "divideKernel"
end

class Num::ModuloKernel(T) < Num::ArithmeticKernel(T)
  @@operator : String = "-"
  @@name : String = "subtractKernel"
end

class Num::BitwiseAndKernel(T) < Num::ArithmeticKernel(T)
  @@operator : String = "&"
  @@name : String = "bitwiseAndKernel"
end

class Num::BitwiseOrKernel(T) < Num::ArithmeticKernel(T)
  @@operator : String = "|"
  @@name : String = "bitwiseOrKernel"
end

class Num::BitwiseXorKernel(T) < Num::ArithmeticKernel(T)
  @@operator : String = "^"
  @@name : String = "bitwiseXorKernel"
end

class Num::RightShiftKernel(T) < Num::ArithmeticKernel(T)
  @@operator : String = ">>"
  @@name : String = "rightShiftKernel"
end

class Num::LeftShiftKernel(T) < Num::ArithmeticKernel(T)
  @@operator : String = "<<"
  @@name : String = "leftShiftKernel"
end

class Num::RelationalKernel(T) < Num::Kernel(T)
  @@operator : String = ""
  @@name : String = ""

  def get_program(dtype)
    "
    #{super}

    #pragma OPENCL EXTENSION cl_khr_fp64 : enable

    __kernel void #{@@name}
                (const int rank,
                const int len,
                __global const int * restrict dst_shape,
                __global const int * restrict dst_strides,
                const int dst_offset,
                __global       int * restrict const dst_data,
                __global const int * restrict A_shape,
                __global const int * restrict A_strides,
                const int A_offset,
                __global const #{dtype} * restrict const A_data,
                __global const int * restrict B_shape,
                __global const int * restrict B_strides,
                const int B_offset,
                __global const #{dtype} * restrict const B_data)
    {
      for (int elemID = get_global_id(0);
      elemID < len;
      elemID += get_global_size(0)) {
        const int dst_real_idx = opencl_getIndexOfElementID(rank, dst_shape, dst_strides, dst_offset, elemID);
        const int A_real_idx = opencl_getIndexOfElementID(rank, A_shape, A_strides, A_offset, elemID);
        const int B_real_idx = opencl_getIndexOfElementID(rank, B_shape, B_strides, B_offset, elemID);
        dst_data[dst_real_idx] = A_data[A_real_idx] #{@@operator} B_data[B_real_idx];
      }
    }
    "
  end

  def call(a : Tensor(T, OCL(T)), b : Tensor(T, OCL(T)))
    a, b = a.broadcast(b)
    result = Tensor(Int32, OCL(Int32)).new(a.shape)
    Cl.args(
      @kernel,
      result.rank,
      result.size,
      result.data.shape,
      result.data.strides,
      result.offset,
      result.to_unsafe,
      a.data.shape,
      a.data.strides,
      a.offset,
      a.to_unsafe,
      b.data.shape,
      b.data.strides,
      b.offset,
      b.to_unsafe
    )
    Cl.run(Num::ClContext.instance.queue, @kernel, result.size)
    result
  end
end

class Num::GreaterKernel(T) < Num::RelationalKernel(T)
  @@operator : String = ">"
  @@name : String = "greaterKernel"
end

class Num::GreaterEqualKernel(T) < Num::RelationalKernel(T)
  @@operator : String = ">="
  @@name : String = "greaterEqualKernel"
end

class Num::LessKernel(T) < Num::RelationalKernel(T)
  @@operator : String = "<"
  @@name : String = "lessKernel"
end

class Num::LessEqualKernel(T) < Num::RelationalKernel(T)
  @@operator : String = "<="
  @@name : String = "lessEqualKernel"
end

class Num::EqualKernel(T) < Num::RelationalKernel(T)
  @@operator : String = "=="
  @@name : String = "equalKernel"
end

class Num::NotEqualKernel(T) < Num::RelationalKernel(T)
  @@operator : String = "!="
  @@name : String = "notEqualKernel"
end

class Num::ArithmeticInplaceKernel(T) < Num::Kernel(T)
  @@operator : String = ""
  @@name : String = ""

  def get_program(dtype)
    "
    #{super}

    #pragma OPENCL EXTENSION cl_khr_fp64 : enable

    __kernel void #{@@name}
                (const int rank,
                const int len,
                __global const int * restrict A_shape,
                __global const int * restrict A_strides,
                const int A_offset,
                __global #{dtype} * A_data,
                __global const int * restrict B_shape,
                __global const int * restrict B_strides,
                const int B_offset,
                __global const #{dtype} * restrict const B_data)
    {
      for (int elemID = get_global_id(0);
      elemID < len;
      elemID += get_global_size(0)) {
        const int A_real_idx = opencl_getIndexOfElementID(rank, A_shape, A_strides, A_offset, elemID);
        const int B_real_idx = opencl_getIndexOfElementID(rank, B_shape, B_strides, B_offset, elemID);
        A_data[A_real_idx] = A_data[A_real_idx] #{@@operator} B_data[B_real_idx];
      }
    }
    "
  end

  def call(a : Tensor(T, OCL(T)), b : Tensor(T, OCL(T)))
    b = b.broadcast_to(a.shape)
    Cl.args(
      @kernel,
      a.rank,
      a.size,
      a.data.shape,
      a.data.strides,
      a.offset,
      a.to_unsafe,
      b.data.shape,
      b.data.strides,
      b.offset,
      b.to_unsafe
    )
    Cl.run(Num::ClContext.instance.queue, @kernel, a.size)
    nil
  end
end

class Num::AddInplaceKernel(T) < Num::ArithmeticInplaceKernel(T)
  @@operator : String = "+"
  @@name : String = "addInplaceKernel"
end

class Num::SubtractInplaceKernel(T) < Num::ArithmeticInplaceKernel(T)
  @@operator : String = "-"
  @@name : String = "subtractInplaceKernel"
end

class Num::MultiplyInplaceKernel(T) < Num::ArithmeticInplaceKernel(T)
  @@operator : String = "*"
  @@name : String = "multiplyInplaceKernel"
end

class Num::DivideInplaceKernel(T) < Num::ArithmeticInplaceKernel(T)
  @@operator : String = "/"
  @@name : String = "divideInplaceKernel"
end
