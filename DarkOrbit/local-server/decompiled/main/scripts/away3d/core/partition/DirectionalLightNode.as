package away3d.core.partition
{
   import away3d.core.traverse.PartitionTraverser;
   import away3d.lights.DirectionalLight;
   
   public class DirectionalLightNode extends EntityNode
   {
      
      private var _light:DirectionalLight;
      
      public function DirectionalLightNode(param1:DirectionalLight)
      {
         super(param1);
         this._light = param1;
      }
      
      public function get light() : DirectionalLight
      {
         return this._light;
      }
      
      override public function acceptTraverser(param1:PartitionTraverser) : void
      {
         if(param1.enterNode(this))
         {
            super.acceptTraverser(param1);
            param1.applyDirectionalLight(this._light);
         }
      }
   }
}

