#nullable enable

using Godot;

public partial class State : Node
{
    [Export]
    public string Label = "State";

    [Export]
    public string Animation { get; set; }

    protected ProjectileCharacter Parent { get; set; }

    public void Init(ProjectileCharacter parent)
    {
        Parent = parent;
    }

    protected void FlipSprite(int direction)
    {
        Parent.GetNode<Sprite2D>("Sprite2D").Scale = new Vector2(
            direction != 0 ? direction : Parent.GetNode<Sprite2D>("Sprite2D").Scale.X,
            1
        );
    }

    protected float GetLateralVelocity(
        float delta,
        float currentVelocity,
        float maximumVelocity,
        float accelerationTime,
        float decelerationTime
    )
    {
        var direction = Parent.MovementController.GetDirection();

        var accelerationFactor = maximumVelocity / accelerationTime;
        var acceleration = direction * accelerationFactor;
        var velocity = currentVelocity + acceleration * delta;
        velocity = Mathf.Clamp(velocity, -maximumVelocity, maximumVelocity);

        if (direction != 0)
        {
            return velocity;
        }

        // No new acceleration, let's decelerate
        var decelerationFactor = maximumVelocity / decelerationTime;
        var deceleration = velocity > 0 ? -decelerationFactor : decelerationFactor;

        velocity += deceleration * delta;

        // Avoid going back in the other direction
        if (deceleration > 0)
        {
            velocity = Mathf.Min(velocity, 0.0f);
        }

        if (deceleration < 0)
        {
            velocity = Mathf.Max(velocity, 0.0f);
        }

        return velocity;
    }

    protected float GetVerticalVelocity(
        float delta,
        float currentVelocity,
        float jumpHeight,
        float jumpTime
    )
    {
        var gravity = 2 * jumpHeight / (jumpTime * jumpTime);

        return currentVelocity + gravity * delta;
    }

    public virtual void Enter(State previousState, float delta)
    {
        var animationPlayer = Parent.GetNode<AnimationPlayer>("AnimationPlayer");
        animationPlayer.CurrentAnimation = Animation;
        animationPlayer.Play();
    }

    public virtual State? GetNextState()
    {
        return null;
    }

    public virtual void Update(float delta) { }

    public virtual Vector2 GetVelocity(float delta)
    {
        return Vector2.Zero;
    }

    public virtual void UpdateSprite()
    {
        FlipSprite(Parent.MovementController.GetDirection());
    }

    public virtual void Exit() { }
}
