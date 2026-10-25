package away3d.animators.states
{
   import away3d.core.base.Geometry;
   
   public interface IVertexAnimationState extends IAnimationState
   {
      
      function get currentGeometry() : Geometry;
      
      function get nextGeometry() : Geometry;
      
      function get blendWeight() : Number;
   }
}

