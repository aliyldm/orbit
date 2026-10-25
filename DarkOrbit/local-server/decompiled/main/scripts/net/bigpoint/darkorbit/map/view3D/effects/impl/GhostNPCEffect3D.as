package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.effects.impl.GhostNPCEffect;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.MapUberAsset3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.GhostMaterial;
   
   public class GhostNPCEffect3D implements IDisposable
   {
      
      private var _view:MapUberAsset3D;
      
      public function GhostNPCEffect3D(param1:MapView3D, param2:GhostNPCEffect)
      {
         super();
         this._view = param1.mainContainer.getViewByTrait(param2.source.getFirstTrait(UberDisplayTrait)) as MapUberAsset3D;
         if(this._view)
         {
            this._view.shader = GhostMaterial;
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._view)
         {
            if(this._view.shader == GhostMaterial)
            {
               this._view.shader = null;
            }
            this._view = null;
         }
      }
   }
}

