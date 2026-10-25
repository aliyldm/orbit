package away3d.animators.states
{
   import away3d.animators.data.SpriteSheetAnimationFrame;
   
   public interface ISpriteSheetAnimationState extends IAnimationState
   {
      
      function get currentFrameData() : SpriteSheetAnimationFrame;
      
      function get currentFrameNumber() : uint;
   }
}

