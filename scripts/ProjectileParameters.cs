using Godot;

public partial class ProjectileParameters : Node
{
    [Export]
    public float JumpHeight { get; set; } = 64;

    [Export]
    public float JumpTime { get; set; } = 0.4f;

    [Export]
    public float FallTime { get; set; } = 0.3f;

    [Export]
    public float JumpMaxDistance { get; set; } = 192;

    [Export]
    public int MaxDoubleJumps { get; set; } = 1;

    [Export]
    public float DoubleJumpHeight { get; set; } = 32;

    [Export]
    public float DoubleJumpTime { get; set; } = 0.3f;

    [Export]
    public float DoubleJumpMaxDistance { get; set; } = 96;

    [Export]
    public float AccelerationTime { get; set; } = 0.1f;

    [Export]
    public float DecelerationTime { get; set; } = 0.1f;

    [Export]
    public float MinimumJumpPressedTime { get; set; } = 0.05f;

    [Export]
    public float MaximumJumpPressedTime { get; set; } = 0.3f;

    [Export]
    public int BufferedJumpFrames { get; set; } = 6;

    [Export]
    public int CoyoteJumpFrames { get; set; } = 6;
}
