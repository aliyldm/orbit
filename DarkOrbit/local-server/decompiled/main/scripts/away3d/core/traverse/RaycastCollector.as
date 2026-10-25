package away3d.core.traverse
{
   import away3d.core.base.IRenderable;
   import away3d.core.partition.NodeBase;
   import away3d.lights.LightBase;
   import flash.geom.Vector3D;
   
   public class RaycastCollector extends EntityCollector
   {
      
      private var _rayPosition:Vector3D = new Vector3D();
      
      private var _rayDirection:Vector3D = new Vector3D();
      
      public function RaycastCollector()
      {
         super();
      }
      
      public function get rayPosition() : Vector3D
      {
         return this._rayPosition;
      }
      
      public function set rayPosition(param1:Vector3D) : void
      {
         this._rayPosition = param1;
      }
      
      public function get rayDirection() : Vector3D
      {
         return this._rayDirection;
      }
      
      public function set rayDirection(param1:Vector3D) : void
      {
         this._rayDirection = param1;
      }
      
      override public function enterNode(param1:NodeBase) : Boolean
      {
         return param1.isIntersectingRay(this._rayPosition,this._rayDirection);
      }
      
      override public function applySkyBox(param1:IRenderable) : void
      {
      }
      
      override public function applyRenderable(param1:IRenderable) : void
      {
      }
      
      override public function applyUnknownLight(param1:LightBase) : void
      {
      }
   }
}

