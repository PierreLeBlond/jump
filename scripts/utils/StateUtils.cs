using Godot;

public class StateUtils
{
    public static float ComputeLateralVelocity(
        float delta,
        float currentVelocity,
        int direction,
        float maximumVelocity,
        float accelerationTime,
        float decelerationTime
    )
    {
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
}
