using Godot;

public partial class Player : CharacterBody2D
{
    [Export]
    public int AccelerationFactor { get; set; } = 600;

    [Export]
    public int DecelerationFactor { get; set; } = 1000;

    [Export]
    public float JumpHeight { get; set; } = 64;

    [Export]
    public float JumpMaxDistance { get; set; } = 192;

    [Export]
    public float JumpRiseTime { get; set; } = 0.4f;

    [Export]
    public float JumpFallTime { get; set; } = 0.3f;

    public Vector2 ScreenSize;

    private bool CanJump = false;

    [Export]
    public int BufferedJumpFrames { get; set; } = 6;
    private int BufferedJumpRemainingFrames = 0;

    [Export]
    public int CoyoteJumpFrames { get; set; } = 6;
    private int CoyoteJumpRemainingFrames = 0;

    public override void _Ready()
    {
        ScreenSize = GetViewportRect().Size;
    }

    private (Vector2, Vector2) AddPlayerMovement(double delta, Vector2 currentVelocity)
    {
        var acceleration = Vector2.Zero;

        if (Input.IsActionPressed("move_right"))
        {
            acceleration.X += AccelerationFactor;
        }

        if (Input.IsActionPressed("move_left"))
        {
            acceleration.X -= AccelerationFactor;
        }

        var maxVelocity = JumpMaxDistance / (JumpRiseTime + JumpFallTime);

        var newVelocity = currentVelocity + acceleration * (float)delta;
        newVelocity.X = Mathf.Clamp(newVelocity.X, -maxVelocity, maxVelocity);

        return (newVelocity, acceleration);
    }

    private Vector2 AddGravity(double delta, Vector2 currentVelocity)
    {
        var gravity = Vector2.Zero;

        var riseGravity = 2 * JumpHeight / (JumpRiseTime * JumpRiseTime);
        var fallGravity = 2 * JumpHeight / (JumpFallTime * JumpFallTime);

        gravity.Y = currentVelocity.Y < 0 ? riseGravity : fallGravity;

        var newVelocity = currentVelocity + gravity * (float)delta;

        return newVelocity;
    }

    private Vector2 AddDeceleration(double delta, Vector2 acceleration, Vector2 currentVelocity)
    {
        var newVelocity = currentVelocity;

        // No previous acceleration to compensate
        if (Length(acceleration) != 0)
        {
            return newVelocity;
        }

        var deceleration = Vector2.Zero;

        if (newVelocity.X > 0)
        {
            deceleration.X -= DecelerationFactor;
        }

        if (newVelocity.X < 0)
        {
            deceleration.X += DecelerationFactor;
        }

        newVelocity.X += deceleration.X * (float)delta;

        // Avoid going back in the other direction
        if (deceleration.X > 0)
        {
            newVelocity.X = Mathf.Min(newVelocity.X, 0.0f);
        }

        if (deceleration.X < 0)
        {
            newVelocity.X = Mathf.Max(newVelocity.X, 0.0f);
        }

        return newVelocity;
    }

    private bool WasOnFloor = false;

    private Vector2 AddPlayerJump(Vector2 currentVelocity)
    {
        if (BufferedJumpRemainingFrames > 0)
        {
            BufferedJumpRemainingFrames--;
        }

        if (Input.IsActionJustPressed("jump"))
        {
            BufferedJumpRemainingFrames = BufferedJumpFrames;
        }

        if (CoyoteJumpRemainingFrames > 0)
        {
            CoyoteJumpRemainingFrames--;
        }

        var isOnFloor = IsOnFloor();

        if (!isOnFloor && WasOnFloor)
        {
            CoyoteJumpRemainingFrames = CoyoteJumpFrames;
        }

        WasOnFloor = isOnFloor;

        var canJump = isOnFloor || CoyoteJumpRemainingFrames > 0;
        var jump = canJump && BufferedJumpRemainingFrames > 0;

        var newVelocity = currentVelocity;

        if (!jump)
        {
            return newVelocity;
        }

        newVelocity.Y -= 2 * JumpHeight / JumpRiseTime;

        // Reset the jump counters
        BufferedJumpRemainingFrames = 0;
        CoyoteJumpRemainingFrames = 0;

        // Remove the ability to coyote jump if we leave the floor due to a jump
        WasOnFloor = false;

        return newVelocity;
    }

    private static float Length(Vector2 v) => Mathf.Sqrt(v.X * v.X + v.Y * v.Y);

    public override void _PhysicsProcess(double delta)
    {
        var (newVelocity, acceleration) = AddPlayerMovement(delta, Velocity);
        newVelocity = AddGravity(delta, newVelocity);
        newVelocity = AddPlayerJump(newVelocity);
        newVelocity = AddDeceleration(delta, acceleration, newVelocity);

        Velocity = newVelocity;
        MoveAndSlide();
    }

    public void OnPlayerTestingUIJumpHeightChanged(double value)
    {
        JumpHeight = (int)value;
    }
}
