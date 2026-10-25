package net.bigpoint.darkorbit.map.view3D.display3D.decorators
{
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.env.collectable.Box;
   import net.bigpoint.darkorbit.map.model.env.collectable.Collectable;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   
   public class CollectableDecorator3D implements IMapUberAssetDecorator3D, IDisposable
   {
      
      private var _trait:UberDisplayTrait;
      
      private var _collectable:Collectable;
      
      private var _viewOwner:UberAsset3D;
      
      public function CollectableDecorator3D()
      {
         super();
      }
      
      public function initialize(param1:UberDisplayTrait, param2:UberAsset3D, param3:Object) : void
      {
         this._trait = param1;
         this._viewOwner = param2;
         this._viewOwner.disposeAnimation = "dispose";
         this._collectable = param1.owner as Collectable;
         this._collectable.collected.add(this.handleCollected);
         if(this._collectable is Box && this._collectable.hash.length == 5)
         {
            this._viewOwner.visible = false;
         }
      }
      
      public function decorate() : void
      {
         if(this._collectable is Box && this._collectable.fresh)
         {
            this._viewOwner.playAnimation("spawnNew");
         }
         else
         {
            this._viewOwner.playAnimation("spawn");
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this.cleanupListeners();
      }
      
      private function handleCollected() : void
      {
         this.cleanupListeners();
         this._viewOwner.disposeAnimation = "collect";
      }
      
      private function cleanupListeners() : void
      {
         this._collectable.collected.remove(this.handleCollected);
      }
   }
}

