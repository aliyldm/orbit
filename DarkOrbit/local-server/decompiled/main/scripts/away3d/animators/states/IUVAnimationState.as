package away3d.animators.states
{
   import away3d.animators.data.UVAnimationFrame;
   
   public interface IUVAnimationState extends IAnimationState
   {
      
      function get currentUVFrame() : UVAnimationFrame;
      
      function get nextUVFrame() : UVAnimationFrame;
      
      function get blendWeight() : Number;
   }
}

