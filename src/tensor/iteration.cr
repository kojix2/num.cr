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

class Tensor(T)
  # Yields the elements of a `Tensor`, always in RowMajor order,
  # as if the `Tensor` was flat.
  #
  # Arguments
  # ---------
  #
  # Examples
  # --------
  # ```
  # a = Tensor.new(2, 2) { |i| i }
  # a.each do |el|
  #   puts el
  # end
  #
  # # 0
  # # 1
  # # 2
  # # 3
  # ```
  def each
    Num::Backend.each(@storage) do |el|
      yield el
    end
  end

  # Yields the memory locations of each element of a `Tensor`, always in
  # RowMajor oder, as if the `Tensor` was flat.
  #
  # This should primarily be used by internal methods.  Methods such
  # as `map!` provided more convenient access to editing the values
  # of a `Tensor`
  #
  # Arguments
  # ---------
  #
  # Examples
  # --------
  # ```
  # a = Tensor.new(2, 2) { |i| i }
  # a.each_pointer do |el|
  #   puts el.value
  # end
  #
  # # 0
  # # 1
  # # 2
  # # 3
  # ```
  def each_pointer
    Num::Backend.each_pointer(@storage) do |el|
      yield el
    end
  end

  # Yields the elements of a `Tensor`, always in RowMajor order,
  # as if the `Tensor` was flat.  Also yields the flat index of each
  # element.
  #
  # Arguments
  # ---------
  #
  # Examples
  # --------
  # ```
  # a = Tensor.new(2, 2) { |i| i }
  # a.each_with_index do |el, i|
  #   puts "#{el}_#{i}"
  # end
  #
  # # 0_0
  # # 1_1
  # # 2_2
  # # 3_3
  # ```
  def each_with_index
    Num::Backend.each_with_index(@storage) do |el, i|
      yield el, i
    end
  end

  # Yields the memory locations of each element of a `Tensor`, always in
  # RowMajor oder, as if the `Tensor` was flat.  Also yields the flat
  # index of a `Tensor`
  #
  # This should primarily be used by internal methods.  Methods such
  # as `map!` provided more convenient access to editing the values
  # of a `Tensor`
  #
  # Arguments
  # ---------
  #
  # Examples
  # --------
  # ```
  # a = Tensor.new(2, 2) { |i| i }
  # a.each_pointer_with_index do |el, i|
  #   puts "#{el.value}_#{i}"
  # end
  #
  # # 0_0
  # # 1_1
  # # 2_2
  # # 3_3
  # ```
  def each_pointer_with_index
    Num::Backend.each_pointer_with_index(@storage) do |el, i|
      yield el, i
    end
  end

  # Maps a block across a `Tensor`.  The `Tensor` is treated
  # as flat during iteration, and iteration is always done
  # in RowMajor order
  #
  # The generic type of the returned `Tensor` is inferred from
  # the block
  #
  # Arguments
  # ---------
  # *block* Proc(T, U)
  #   Proc to map across the `Tensor`
  #
  # Examples
  # --------
  # ```
  # a = Tensor.new([3]) { |i| i }
  # a.map { |e| e + 5 } # => [5, 6, 7]
  # ```
  def map(&block : T -> U) : Tensor(U) forall U
    Num::Backend.map(@storage) { |el| yield el }
  end

  # Maps a block across a `Tensor` in place.  The `Tensor` is treated
  # as flat during iteration, and iteration is always done
  # in RowMajor order
  #
  # Arguments
  # ---------
  # *block* Proc(T, U)
  #   Proc to map across the `Tensor`
  #
  # Examples
  # --------
  # ```
  # a = Tensor.new([3]) { |i| i }
  # a.map! { |e| e + 5 }
  # a # => [5, 6, 7]
  # ```
  def map!(&block)
    Num::Backend.map!(@storage) { |el| yield el }
  end

  # Maps a block across two `Tensors`.  This is more efficient than
  # zipping iterators since it iterates both `Tensor`'s in a single
  # call, avoiding overhead from tracking multiple iterators.
  #
  # The generic type of the returned `Tensor` is inferred from a block
  #
  # Arguments
  # ---------
  # *t* : Tensor(U)
  #   The second `Tensor` for iteration.  Must be broadcastable
  #   against the `shape` of `self`
  # *block* : Proc(T, U, V)
  #   The block to map across both `Tensor`s
  #
  # Examples
  # --------
  # ```
  # a = Tensor.new([3]) { |i| i }
  # b = Tensor.new([3]) { |i| i }
  #
  # a.map(b) { |i, j| i + j } # => [0, 2, 4]
  # ```
  def map(t : Tensor(U), &block : T, U -> V) : Tensor(V) forall U, V
    Num::Backend.map(@storage, t.storage) do |i, j|
      yield i, j
    end
  end

  # Maps a block across two `Tensors`.  This is more efficient than
  # zipping iterators since it iterates both `Tensor`'s in a single
  # call, avoiding overhead from tracking multiple iterators.
  # The result of the block is stored in `self`.
  #
  # Broadcasting rules still apply, but since this is an in place
  # operation, the other `Tensor` must broadcast to the shape of `self`
  #
  # Arguments
  # ---------
  # *t* : Tensor(U)
  #   The second `Tensor` for iteration.  Must be broadcastable
  #   against the `shape` of `self`
  # *block* : Proc(T, U, T)
  #   The block to map across both `Tensor`s
  #
  # Examples
  # --------
  # ```
  # a = Tensor.new([3]) { |i| i }
  # b = Tensor.new([3]) { |i| i }
  #
  # a.map!(b) { |i, j| i + j }
  # a # => [0, 2, 4]
  # ```
  def map!(d2 : Tensor(U), &block) forall U
    Num::Backend.map!(@storage, d2.storage) do |i, j|
      yield i, j
    end
  end

  # Maps a block across three `Tensors`.  This is more efficient than
  # zipping iterators since it iterates all `Tensor`'s in a single
  # call, avoiding overhead from tracking multiple iterators.
  #
  # The generic type of the returned `Tensor` is inferred from a block
  #
  # Arguments
  # ---------
  # *t* : Tensor(U)
  #   The second `Tensor` for iteration.  Must be broadcastable
  #   against the `shape` of `self` and `v`
  # *v) : Tensor(V)
  #   The third `Tensor` for iteration.  Must be broadcastable
  #   against the `shape` of `self` and `t`
  # *block* : Proc(T, U, V, W)
  #   The block to map across all `Tensor`s
  #
  # Examples
  # --------
  # ```
  # a = Tensor.new([3]) { |i| i }
  # b = Tensor.new([3]) { |i| i }
  # c = Tensor.new([3]) { |i| i }
  #
  # a.map(b, c) { |i, j, k| i + j + k } # => [0, 3, 6]
  # ```
  def map(
    d1 : Tensor(U),
    d2 : Tensor(V),
    &block : T, U, V -> W
  ) : Tensor(W) forall T, U, V, W
    Num::Backend.map(@storage, d1.storage, d2.storage) do |i, j, k|
      yield i, j, k
    end
  end

  # Maps a block across three `Tensors`.  This is more efficient than
  # zipping iterators since it iterates all `Tensor`'s in a single
  # call, avoiding overhead from tracking multiple iterators.
  # The result of the block is stored in `self`.
  #
  # Broadcasting rules still apply, but since this is an in place
  # operation, the other `Tensor`'s must broadcast to the shape of `self`
  #
  # Arguments
  # ---------
  # *t* : Tensor(U)
  #   The second `Tensor` for iteration.  Must be broadcastable
  #   against the `shape` of `self` and `v`
  # *v) : Tensor(V)
  #   The third `Tensor` for iteration.  Must be broadcastable
  #   against the `shape` of `self` and `t`
  # *block* : Proc(T, U, V, W)
  #   The block to map across all `Tensor`s
  #
  # Examples
  # --------
  # ```
  # a = Tensor.new([3]) { |i| i }
  # b = Tensor.new([3]) { |i| i }
  # c = Tensor.new([3]) { |i| i }
  #
  # a.map!(b, c) { |i, j, k| i + j + k }
  # a # => [0, 3, 6]
  # ```
  def map!(d1 : Tensor(V), d2 : Tensor(W), &block) forall U, V, W
    Num::Backend.map!(@storage, d1.storage, d2.storage) do |i, j, k|
      yield i, j, k
    end
  end
end
