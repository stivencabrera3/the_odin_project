require_relative '../lib/rook'
require_relative '../lib/gamepiece'
require_relative '../lib/board'

describe Rook do
  let(:chess_board) { Board.new }

  describe '#valid_move?' do
    subject(:rook_move) { described_class.new([3,3], 'white') }

    context 'when new_pos[0] is off the board' do
      it 'returns false' do
        new_pos = [8,3]
      
        expect(rook_move.valid_move?(new_pos, chess_board)). to be false
      end
    end

    context 'when new_pos[1] is off the board' do
      it 'returns false' do
        new_pos = [3,8]
      
        expect(rook_move.valid_move?(new_pos, chess_board)). to be false
      end
    end

    context 'when path from pos to new_pos is not linear' do
      it 'returns false' do
        new_pos = [4,4]
        expect(rook_move.valid_move?(new_pos, chess_board)).to be false
      end
    end

    context 'when path from pos to new_pos is linear' do
      it 'returns true' do
        new_pos = [4,3]
        expect(rook_move.valid_move?(new_pos, chess_board)).to be true
      end

      it 'works with other linear paths' do 
        new_pos = [3,6]
        expect(rook_move.valid_move?(new_pos, chess_board)).to be true
      end
    end

    context 'when a friendly piece is on the new_pos board node' do
      let(:friendly_rook) { described_class.new([7,3], 'white') }

      it 'returns false' do
        new_pos = [7,3]
        new_pos_node = chess_board.find_node(new_pos)
        new_pos_node.piece = friendly_rook

        expect(rook_move.valid_move?(new_pos, chess_board)).to be false 
      end
    end

    context 'when a enemy piece is on the new_pos board node' do
      let(:enemy_rook) { described_class.new([7,3], 'black') }

      it 'returns true' do
        new_pos = [7,3]
        new_pos_node = chess_board.find_node(new_pos)
        new_pos_node.piece = enemy_rook

        expect(rook_move.valid_move?(new_pos, chess_board)).to be true 
      end
    end

    context 'when piece is between pos and new_pos path ' do
      let(:rook) { described_class.new([5,3]) }

      it 'returns false' do
        new_pos = [7,3]
        path_node = chess_board.find_node([5,3])
        path_node.piece = rook

        expect(rook_move.valid_move?(new_pos, chess_board)).to be false
      end
    end

    context 'when path between pos and valid new_pos is clear' do
      it 'returns true' do
        new_pos = [0,3]

        expect(rook_move.valid_move?(new_pos, chess_board)).to be true
      end
    end
    context 'when new_pos passes all conditions' do
      it 'returns true' do
        new_pos = [2,3]

        expect(rook_move.valid_move?(new_pos, chess_board)).to be true
      end

      it 'works with other valid new_pos' do
        new_pos = [3,1]

        expect(rook_move.valid_move?(new_pos, chess_board)).to be true
      end 
    end
  end

  describe '#get_path' do
    subject(:rook_path) { described_class.new([3,3], 'white') }

    context 'when passed a start_pos and valid end_pos' do
      it 'returns a non-empty array' do
        start_pos = [3,3]
        end_pos = [7,3]
        result = rook_path.get_path(start_pos, end_pos, chess_board)

        expect(result).to_not be_empty
      end
      
      it 'returns array only with nodes between but not equal to start_pos and end_pos' do
        start_pos = [3,3]
        end_pos = [7,3]
        result = rook_path.get_path(start_pos, end_pos, chess_board)

        expect(result.any? { |node| node.coor == start_pos || node.coor == end_pos }).to be false
      end

      it 'returns array of the expected length' do
        start_pos = [3,3]
        end_pos = [3,0]
        result = rook_path.get_path(start_pos, end_pos, chess_board)

        expect(result.length).to eq(2)
      end
    end
  end
end