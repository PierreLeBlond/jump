using Godot;

public partial class JumpCurve : Node2D
{
    public CharacterBody2D OriginNode;
    public ProjectileParameters ProjectileParameters;

    private int direction = 1;
    private Vector2 center;

    private Vector2 GetCurvePoint(float t, float maximumVelocity, float a, float b, Vector2 center)
    {
        var x = maximumVelocity * t;
        var y = a * t * t + b * t;
        return center + new Vector2(x, y);
    }

    private void DrawCurve(
        Vector2 center,
        float startTime,
        float endTime,
        float a,
        float b,
        float maximumVelocity,
        Color color
    )
    {
        int nbPoints = 8;
        var pointsArc = new Vector2[nbPoints];

        for (int i = 0; i < nbPoints; ++i)
        {
            var t = startTime + (endTime - startTime) * i / (nbPoints - 1);
            pointsArc[i] = GetCurvePoint(t, maximumVelocity, a, b, center);
        }

        for (int i = 0; i < nbPoints - 1; ++i)
            DrawLine(pointsArc[i], pointsArc[i + 1], color, 2, true);
    }

    public override void _Draw()
    {
        if (OriginNode.Velocity.X > 0)
        {
            direction = 1;
        }

        if (OriginNode.Velocity.X < 0)
        {
            direction = -1;
        }

        if (OriginNode.IsOnFloor())
        {
            center = OriginNode.Transform.Origin;
        }
        var color = new Color(1, 0, 0);

        var gravity =
            2
            * ProjectileParameters.JumpHeight
            / (ProjectileParameters.JumpTime * ProjectileParameters.JumpTime);
        var maximumVelocity =
            direction
            * ProjectileParameters.JumpMaxDistance
            / (ProjectileParameters.JumpTime + ProjectileParameters.FallTime);

        DrawCurve(
            center,
            0,
            ProjectileParameters.JumpTime,
            gravity / 2,
            -2 * ProjectileParameters.JumpHeight / ProjectileParameters.JumpTime,
            maximumVelocity,
            color
        );

        var fallCenter = GetCurvePoint(
            ProjectileParameters.JumpTime,
            maximumVelocity,
            gravity / 2,
            -2 * ProjectileParameters.JumpHeight / ProjectileParameters.JumpTime,
            center
        );
        var fallColor = new Color(0, 0, 1);
        var fallGravity =
            2
            * ProjectileParameters.JumpHeight
            / (ProjectileParameters.FallTime * ProjectileParameters.FallTime);

        DrawCurve(
            fallCenter,
            0,
            ProjectileParameters.FallTime,
            fallGravity / 2,
            0,
            maximumVelocity,
            fallColor
        );

        var doubleJumpColor = new Color(1, 0, 0);
        var doubleJumpGravity =
            2
            * ProjectileParameters.DoubleJumpHeight
            / (ProjectileParameters.DoubleJumpTime * ProjectileParameters.DoubleJumpTime);
        var doubleJumpMaximumVelocity =
            direction
            * ProjectileParameters.DoubleJumpMaxDistance
            / (ProjectileParameters.DoubleJumpTime + ProjectileParameters.FallTime);

        DrawCurve(
            fallCenter,
            0,
            ProjectileParameters.DoubleJumpTime,
            doubleJumpGravity / 2,
            -2 * ProjectileParameters.DoubleJumpHeight / ProjectileParameters.DoubleJumpTime,
            doubleJumpMaximumVelocity,
            doubleJumpColor
        );

        var doubleFallCenter = GetCurvePoint(
            ProjectileParameters.DoubleJumpTime,
            doubleJumpMaximumVelocity,
            doubleJumpGravity / 2,
            -2 * ProjectileParameters.DoubleJumpHeight / ProjectileParameters.DoubleJumpTime,
            fallCenter
        );
        var doubleFallColor = new Color(0, 0, 1);

        DrawCurve(
            doubleFallCenter,
            0,
            ProjectileParameters.FallTime,
            fallGravity / 2,
            0,
            maximumVelocity,
            doubleFallColor
        );
    }

    public override void _Process(double delta)
    {
        QueueRedraw();
    }
}
