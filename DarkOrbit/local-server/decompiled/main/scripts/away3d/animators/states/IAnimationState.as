package away3d.animators.states
{
   import flash.geom.Vector3D;
   
   public interface IAnimationState
   {
      
      function get positionDelta() : Vector3D;
      
      function set time(param1:int) : void;
   }
}

