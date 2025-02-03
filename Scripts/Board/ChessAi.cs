using Godot;
using System;
using System.Collections.Generic;
public partial class ChessAi : Node
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}
	public string[,] ConvertAndUseBoard(string[] godotArray)
    {
        // Initialize a new 2D array (string[,])
        string[,] board = new string[8, 8];  // 8x8 board for chess
        
        // Copy the contents of the 1D Godot array into the C# 2D array (string[,])
        int index = 0;
        for (int i = 0; i < 8; i++)  // Loop through rows
        {
            for (int j = 0; j < 8; j++)  // Loop through columns
            {
                // Assign values from the 1D array to the 2D array
                board[i, j] = godotArray[index];
                index++;
            }
        }
		return board;
	}
	public string get_best_move(string[] arr)
	{
		// Create a 2D string array
		string[,] board = new string[8, 8];
		int index = 0;

		// Convert the 1D array into a 2D array
		for (int i = 0; i < 8; i++)
		{
			for (int j = 0; j < 8; j++)
			{
				board[i, j] = arr[index++];
			}
		}

		// Now you have the 2D array, print it
		for (int i = 0; i < 8; i++)
		{
			string row = "";
			for (int j = 0; j < 8; j++)
			{
				row += board[i, j] + " ";
			}
		}
		string best_move = BestMove(board, 4);
		return best_move;
	}
	private static readonly Dictionary<string, int> PieceValues = new Dictionary<string, int>
    {
        { "p", 1 },  // Black pawn
        { "r", 5 },  // Black rook
        { "n", 3 },  // Black knight
        { "b", 3 },  // Black bishop
        { "q", 9 },  // Black queen
        { "k", 30 }, // Black king
        { "P", -1 }, // White pawn
        { "R", -5 }, // White rook
        { "N", -3 }, // White knight
        { "B", -3 }, // White bishop
        { "Q", -9 }, // White queen
        { "K", -150 }, // White king
        { "0", 0 }   // Empty square
    };
	private static int Minimax(string[,] board, int depth, bool isMaximizing, int alpha, int beta)
	{
		// Base case: return the board evaluation if depth is 0 or the game is over
		if (depth == 0 || IsGameOver(board))
		{
			return EvaluateBoard(board);
		}

		if (isMaximizing)
		{
			int maxEval = int.MinValue;

			foreach (var move in GenerateAllPossibleMoves(board, "black"))
			{
				string[,] newBoard = ApplyMove(board, move);
				int eval = Minimax(newBoard, depth - 1, false, alpha, beta);
				maxEval = Math.Max(maxEval, eval);

				// Update alpha and prune if beta <= alpha
				alpha = Math.Max(alpha, eval);
				if (beta <= alpha)
					break; // Prune remaining branches
			}

			return maxEval;
		}
		else
		{
			int minEval = int.MaxValue;

			foreach (var move in GenerateAllPossibleMoves(board, "white"))
			{
				string[,] newBoard = ApplyMove(board, move);
				int eval = Minimax(newBoard, depth - 1, true, alpha, beta);
				minEval = Math.Min(minEval, eval);

				// Update beta and prune if beta <= alpha
				beta = Math.Min(beta, eval);
				if (beta <= alpha)
					break; // Prune remaining branches
			}

			return minEval;
		}
	}
	public static string BestMove(string[,] currentBoard, int depth)
	{
		int bestScore = int.MinValue;
		string bestMove = "";
		int alpha = int.MinValue;
		int beta = int.MaxValue;

		foreach (var move in GenerateAllPossibleMoves(currentBoard, "black"))
		{
			string[,] newBoard = ApplyMove(currentBoard, move);
			int score = Minimax(newBoard, depth - 1, false, alpha, beta);

			if (score > bestScore)
			{
				bestScore = score;
				bestMove = move;
			}

			// Update alpha
			alpha = Math.Max(alpha, score);
		}

		return bestMove;
	}

    private static int Minimax(string[,] board, int depth, bool isMaximizing)
    {
        if (depth == 0 || IsGameOver(board))
        {
            return EvaluateBoard(board);
        }

        if (isMaximizing)
        {
            int maxEval = int.MinValue;

            foreach (var move in GenerateAllPossibleMoves(board, "black"))
            {
                string[,] newBoard = ApplyMove(board, move);
                int eval = Minimax(newBoard, depth - 1, false);
                maxEval = Math.Max(maxEval, eval);
            }

            return maxEval;
        }
        else
        {
            int minEval = int.MaxValue;

            foreach (var move in GenerateAllPossibleMoves(board, "white"))
            {
                string[,] newBoard = ApplyMove(board, move);
                int eval = Minimax(newBoard, depth - 1, true);
                minEval = Math.Min(minEval, eval);
            }

            return minEval;
        }
    }

    private static int EvaluateBoard(string[,] board)
    {
        int score = 0;

        foreach (string piece in board)
        {
            score += PieceValues[piece];
        }

        return score;
    }

    private static bool IsGameOver(string[,] board)
    {
        bool whiteKing = false;
        bool blackKing = false;

        foreach (string piece in board)
        {
            if (piece == "K") whiteKing = true;
            if (piece == "k") blackKing = true;
        }

        return !(whiteKing && blackKing); // Game over if one king is missing
    }

    private static List<string> GenerateAllPossibleMoves(string[,] board, string color)
	{
		var moves = new List<string>();

		for (int row = 0; row < 8; row++)
		{
			for (int col = 0; col < 8; col++)
			{
				string piece = board[row, col];

				if ((color == "white" && char.IsUpper(piece[0])) ||
					(color == "black" && char.IsLower(piece[0])))
				{
					// Generate moves based on the piece type
					switch (char.ToLower(piece[0]))
					{
						case 'p': // Pawn
							moves.AddRange(GeneratePawnMoves(board, row, col, color));
							break;
						case 'r': // Rook
							moves.AddRange(GenerateRookMoves(board, row, col, color));
							break;
						case 'n': // Knight
							moves.AddRange(GenerateKnightMoves(board, row, col, color));
							break;
						case 'b': // Bishop
							moves.AddRange(GenerateBishopMoves(board, row, col, color));
							break;
						case 'q': // Queen
							moves.AddRange(GenerateQueenMoves(board, row, col, color));
							break;
						case 'k': // King
							moves.AddRange(GenerateKingMoves(board, row, col, color));
							break;
					}
				}
			}
		}

    	return moves;
	}

    private static string[,] ApplyMove(string[,] board, string move)
	{
		string[,] newBoard = (string[,])board.Clone();

		// Parse the move string
		int fromRow = int.Parse(move.Substring(0, 1)); // Get row from position 0-1
		int fromCol = int.Parse(move.Substring(1, 1)); // Get col from position 1-2
		int toRow = int.Parse(move.Substring(2, 1)); // Get row from position 2-3
		int toCol = int.Parse(move.Substring(3, 1)); // Get col from position 3-4

		// Validate the parsed indices
		if (fromRow < 0 || fromRow >= 8 || fromCol < 0 || fromCol >= 8 ||
			toRow < 0 || toRow >= 8 || toCol < 0 || toCol >= 8)
		{
			throw new IndexOutOfRangeException($"Invalid move: {move}. Coordinates are out of bounds.");
		}

		// Perform the move (copy the piece to the new location and clear the old one)
		newBoard[toRow, toCol] = newBoard[fromRow, fromCol];
		newBoard[fromRow, fromCol] = "0"; // Empty the original square

		return newBoard;
	}
	private static bool IsInBounds(int row, int col)
	{
    return row >= 0 && row < 8 && col >= 0 && col < 8;
	}

	private static bool IsEnemyPiece(string piece, string color)
	{
    if (color == "white")
        return char.IsLower(piece[0]); // Enemy pieces are lowercase for white
    else
        return char.IsUpper(piece[0]); // Enemy pieces are uppercase for black
	}
	private static List<string> GeneratePawnMoves(string[,] board, int row, int col, string color)
	{
		var moves = new List<string>();
		int direction = color == "white" ? -1 : 1; // White moves up, black moves down

		// Forward move
		if (IsInBounds(row + direction, col) && board[row + direction, col] == "0")
		{
			moves.Add($"{row}{col}{row + direction}{col}");
		}

		// Double forward move (only from starting rank)
		if ((color == "white" && row == 6 || color == "black" && row == 1) &&
			board[row + direction, col] == "0" &&
			board[row + 2 * direction, col] == "0")
		{
			moves.Add($"{row}{col}{row + 2 * direction}{col}");
		}

		// Capture moves
		if (IsInBounds(row + direction, col - 1) && IsEnemyPiece(board[row + direction, col - 1], color))
		{
			moves.Add($"{row}{col}{row + direction}{col - 1}");
		}
		if (IsInBounds(row + direction, col + 1) && IsEnemyPiece(board[row + direction, col + 1], color))
		{
			moves.Add($"{row}{col}{row + direction}{col + 1}");
		}

		return moves;
	}
	private static List<string> GenerateRookMoves(string[,] board, int row, int col, string color)
	{
		var moves = new List<string>();

		// Horizontal and vertical directions
		int[] directions = { -1, 1 };

		// Check all directions (left, right, up, down)
		foreach (int dir in directions)
		{
			// Vertical (up and down)
			for (int i = 1; IsInBounds(row + i * dir, col); i++)
			{
				if (board[row + i * dir, col] == "0") // Empty square
				{
					moves.Add($"{row}{col}{row + i * dir}{col}");
				}
				else if (IsEnemyPiece(board[row + i * dir, col], color)) // Capture
				{
					moves.Add($"{row}{col}{row + i * dir}{col}");
					break;
				}
				else break; // Blocked
			}

			// Horizontal (left and right)
			for (int i = 1; IsInBounds(row, col + i * dir); i++)
			{
				if (board[row, col + i * dir] == "0") // Empty square
				{
					moves.Add($"{row}{col}{row}{col + i * dir}");
				}
				else if (IsEnemyPiece(board[row, col + i * dir], color)) // Capture
				{
					moves.Add($"{row}{col}{row}{col + i * dir}");
					break;
				}
				else break; // Blocked
			}
		}

		return moves;
	}
	private static List<string> GenerateKnightMoves(string[,] board, int row, int col, string color)
	{
		var moves = new List<string>();
		int[][] knightOffsets = {
			new int[] { -2, -1 }, new int[] { -2, 1 }, new int[] { -1, -2 }, new int[] { -1, 2 },
			new int[] { 1, -2 }, new int[] { 1, 2 }, new int[] { 2, -1 }, new int[] { 2, 1 }
		};

		foreach (var offset in knightOffsets)
		{
			int newRow = row + offset[0];
			int newCol = col + offset[1];
			if (IsInBounds(newRow, newCol) && (board[newRow, newCol] == "0" || IsEnemyPiece(board[newRow, newCol], color)))
			{
				moves.Add($"{row}{col}{newRow}{newCol}");
			}
		}

		return moves;
	}
	private static List<string> GenerateBishopMoves(string[,] board, int row, int col, string color)
	{
    	return GenerateSlidingMoves(board, row, col, color, new int[,] { { -1, -1 }, { -1, 1 }, { 1, -1 }, { 1, 1 } });
	}
	private static List<string> GenerateQueenMoves(string[,] board, int row, int col, string color)
	{
		return GenerateSlidingMoves(board, row, col, color, new int[,] { 
			{ -1, -1 }, { -1, 1 }, { 1, -1 }, { 1, 1 },  // Diagonal
			{ -1, 0 }, { 1, 0 }, { 0, -1 }, { 0, 1 }    // Straight
		});
	}
	private static List<string> GenerateKingMoves(string[,] board, int row, int col, string color)
	{
		var moves = new List<string>();
		int[][] kingOffsets = {
			new int[] { -1, -1 }, new int[] { -1, 0 }, new int[] { -1, 1 },
			new int[] { 0, -1 }, new int[] { 0, 1 },
			new int[] { 1, -1 }, new int[] { 1, 0 }, new int[] { 1, 1 }
		};

		foreach (var offset in kingOffsets)
		{
			int newRow = row + offset[0];
			int newCol = col + offset[1];
			if (IsInBounds(newRow, newCol) && (board[newRow, newCol] == "0" || IsEnemyPiece(board[newRow, newCol], color)))
			{
				moves.Add($"{row}{col}{newRow}{newCol}");
			}
		}

		// Placeholder: Add castling logic here
		return moves;
	}
	private static List<string> GenerateSlidingMoves(string[,] board, int row, int col, string color, int[,] directions)
	{
		var moves = new List<string>();

		int[][] directions_slide = {
			new int[] { -1, -1 }, new int[] { -1, 1 }, new int[] { 1, -1 }, new int[] { 1, 1 }, // Diagonal
			new int[] { -1, 0 }, new int[] { 1, 0 }, new int[] { 0, -1 }, new int[] { 0, 1 }   // Straight
		};

		foreach (var direction in directions_slide)
		{
			int dRow = direction[0], dCol = direction[1];

			for (int i = 1; IsInBounds(row + i * dRow, col + i * dCol); i++)
			{
				int newRow = row + i * dRow;
				int newCol = col + i * dCol;

				if (board[newRow, newCol] == "0") // Empty square
				{
					moves.Add($"{row}{col}{newRow}{newCol}");
				}
				else if (IsEnemyPiece(board[newRow, newCol], color)) // Capture
				{
					moves.Add($"{row}{col}{newRow}{newCol}");
					break; // Block further movement
				}
				else break; // Blocked by same-color piece
			}
		}

		return moves;
	}
}

