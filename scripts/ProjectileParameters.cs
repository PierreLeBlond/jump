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
    public float JumpDistance { get; set; } = 192;

    public float MaximumVelocity => JumpDistance / (JumpTime + FallTime);

    [Export]
    public int MaxDoubleJumps { get; set; } = 1;

    [Export]
    public float DoubleJumpHeight { get; set; } = 32;

    [Export]
    public float DoubleJumpTime { get; set; } = 0.3f;

    [Export]
    public float DoubleJumpDistance { get; set; } = 96;

    public float DoubleJumpMaximumVelocity => DoubleJumpDistance / (DoubleJumpTime + FallTime);

    [Export]
    public float AccelerationTime { get; set; } = 0.1f;

    [Export]
    public float DecelerationTime { get; set; } = 0.1f;

    [Export]
    public float AirAccelerationTime { get; set; } = 0.25f;

    [Export]
    public float AirDecelerationTime { get; set; } = 0.15f;


    // We don't want the player to be able to move back to the wall after the wall jump, hence less air controls

    [Export]
    public float WallJumpAccelerationTime { get; set; } = 0.45f;

    [Export]
    public float WallJumpDecelerationTime { get; set; } = 0.35f;

    [Export]
    public float RunFactor { get; set; } = 1.5f;

    [Export]
    public float WallFrictionFactor { get; set; } = 0.5f;

    [Export]
    public float MinimumJumpPressedTime { get; set; } = 0.05f;

    [Export]
    public float MaximumJumpPressedTime { get; set; } = 0.3f;

    [Export]
    public int BufferedJumpFrames { get; set; } = 6;

    [Export]
    public int CoyoteJumpFrames { get; set; } = 6;
}
