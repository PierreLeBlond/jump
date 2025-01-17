#nullable enable

using Godot;

public partial class State : Node
{
    [Export]
    public string Label = "State";

    [Export]
    public Vector2 SpriteOffset { get; set; }

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

    public virtual void Enter(State previousState, float delta)
    {
        var regionRect = Parent.GetNode<Sprite2D>("Sprite2D").GetRegionRect();
        regionRect.Position = SpriteOffset;
        Parent.GetNode<Sprite2D>("Sprite2D").SetRegionRect(regionRect);
    }

    public virtual void Exit() { }

    public virtual State? HandlePhysics(float delta)
    {
        return null;
    }
}
