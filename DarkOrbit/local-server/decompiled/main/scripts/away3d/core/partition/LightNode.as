package away3d.core.partition
{
   import away3d.core.traverse.PartitionTraverser;
   import away3d.lights.LightBase;
   
   public class LightNode extends EntityNode
   {
      
      private var _light:LightBase;
      
      public function LightNode(param1:LightBase)
      {
         super(param1);
         this._light = param1;
      }
      
      public function get light() : LightBase
      {
         return this._light;
      }
      
      override public function acceptTraverser(param1:PartitionTraverser) : void
      {
         if(param1.enterNode(this))
         {
            super.acceptTraverser(param1);
            param1.applyUnknownLight(this._light);
         }
      }
   }
}

