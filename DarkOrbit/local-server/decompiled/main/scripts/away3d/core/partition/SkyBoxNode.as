package away3d.core.partition
{
   import away3d.core.math.Plane3D;
   import away3d.core.traverse.PartitionTraverser;
   import away3d.primitives.SkyBox;
   
   public class SkyBoxNode extends EntityNode
   {
      
      private var _skyBox:SkyBox;
      
      public function SkyBoxNode(param1:SkyBox)
      {
         super(param1);
         this._skyBox = param1;
      }
      
      override public function acceptTraverser(param1:PartitionTraverser) : void
      {
         if(param1.enterNode(this))
         {
            super.acceptTraverser(param1);
            param1.applySkyBox(this._skyBox);
         }
      }
      
      override public function isInFrustum(param1:Vector.<Plane3D>, param2:int) : Boolean
      {
         param1 = param1;
         param2 = param2;
         return true;
      }
   }
}

