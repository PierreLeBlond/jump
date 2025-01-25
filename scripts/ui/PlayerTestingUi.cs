using Godot;

public partial class PlayerTestingUi : Control
{
    [Export]
    public ProjectileCharacter Player;

    [Export]
    public TestingSlider JumpHeightSlider;

    [Export]
    public TestingSlider JumpTimeSlider;

    [Export]
    public TestingSlider FallTimeSlider;

    [Export]
    public TestingSlider JumpMaxDistanceSlider;

    [Export]
    public JumpCurve JumpCurve;

    public override void _Ready()
    {
        JumpHeightSlider.Init(Player.ProjectileParameters.JumpHeight);
        JumpHeightSlider.ValueChanged += (float value) =>
        {
            Player.ProjectileParameters.JumpHeight = value;
        };

        JumpTimeSlider.Init(Player.ProjectileParameters.JumpTime);
        JumpTimeSlider.ValueChanged += (float value) =>
        {
            Player.ProjectileParameters.JumpTime = value;
        };

        FallTimeSlider.Init(Player.ProjectileParameters.FallTime);
        FallTimeSlider.ValueChanged += (float value) =>
        {
            Player.ProjectileParameters.FallTime = value;
        };

        JumpMaxDistanceSlider.Init(Player.ProjectileParameters.JumpMaxDistance);
        JumpMaxDistanceSlider.ValueChanged += (float value) =>
        {
            Player.ProjectileParameters.JumpMaxDistance = value;
        };

        JumpCurve.OriginNode = Player;

        JumpCurve.ProjectileParameters = Player.ProjectileParameters;
    }
}
