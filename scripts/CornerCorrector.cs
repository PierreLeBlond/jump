using Godot;

public partial class CornerCorrector : Node
{
  private ProjectileCharacter Parent { get; set; }

  [Export]
  public RayCast2D OuterLeftCeilingRayCast2D { get; set; }

  [Export]
  public RayCast2D InnerLeftCeilingRayCast2D { get; set; }

  [Export]
  public RayCast2D OuterRightCeilingRayCast2D { get; set; }

  [Export]
  public RayCast2D InnerRightCeilingRayCast2D { get; set; }

  public void Init(ProjectileCharacter parent) {
    Parent = parent;
  }

  public void ApplyCornerCorrection() {
    var outerLeft = OuterLeftCeilingRayCast2D;
    var innerLeft = InnerLeftCeilingRayCast2D;
    var outerRight = OuterRightCeilingRayCast2D;
    var innerRight = InnerRightCeilingRayCast2D;

    // Using ceil and floor to avoid subpixel positions can result in off by one pixel when moving away the projectile from the corner.

    if (outerLeft.IsColliding() && !innerLeft.IsColliding())
    {
      var x = Mathf.Floor(outerLeft.GetCollisionPoint().X);
      var offset = 16 - (x % 16);
      Parent.Position = new Vector2(Parent.Position.X + offset, Parent.Position.Y);
    }

    if (outerRight.IsColliding() && !innerRight.IsColliding())
    {
      var x = Mathf.Ceil(outerRight.GetCollisionPoint().X);
      var offset = x % 16;
      Parent.Position = new Vector2(Parent.Position.X - offset, Parent.Position.Y);
    }
  }
}