package away3d.animators.states
{
   import away3d.animators.nodes.VertexClipNode;
   import away3d.core.base.Geometry;
   
   public class VertexClipFrame
   {
      
      private static var UID:int = 0;
      
      public var uid:uint = ++UID;
      
      public var geometry:Geometry;
      
      public var duration:int = 0;
      
      public var blendType:uint = VertexClipNode.BLEND_LINEAR;
      
      public function VertexClipFrame(param1:Geometry, param2:int, param3:uint = 0)
      {
         super();
         this.geometry = param1;
         this.duration = param2;
         this.blendType = param3;
      }
   }
}

