package net.bigpoint.darkorbit.map.view3D.display3D.decorators
{
   import com.greensock.TweenLite;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.MoveTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.MapUberAsset3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.ship.drones.Drone3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   
   public class MimesisDecorator3D implements IMapUberAssetDecorator3D, IDisposable
   {
      
      private var _trait:UberDisplayTrait;
      
      private var _viewOwner:MapUberAsset3D;
      
      private var _moveTrait:MoveTrait;
      
      private var _isOpen:Boolean = true;
      
      private var _ship:Ship;
      
      public function MimesisDecorator3D()
      {
         super();
      }
      
      public function initialize(param1:UberDisplayTrait, param2:UberAsset3D, param3:Object) : void
      {
         this._viewOwner = param2 as MapUberAsset3D;
         this._trait = param1;
         this._moveTrait = this._trait.owner.getFirstTrait(MoveTrait) as MoveTrait;
         this._ship = this._trait.owner as Ship;
         this._ship.hasDesignSet.changed.add(this.hasMimesisSetChanged);
      }
      
      public function hasMimesisSetChanged() : void
      {
         if(this._ship.hasDesignSet.value)
         {
            this.decorate();
         }
         else
         {
            this.removeListeners();
            if(!this._isOpen)
            {
               this.playOpen();
               this._isOpen = true;
            }
         }
      }
      
      public function decorate() : void
      {
         if(this._ship.hasDesignSet.value)
         {
            this._moveTrait.moveStarted.add(this.close);
            this._moveTrait.moveStopped.add(this.open);
            if(this._ship.moveTrait.isMoving)
            {
               this.close();
            }
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this._ship.hasDesignSet.changed.remove(this.hasMimesisSetChanged);
         this.removeListeners();
         this._trait = null;
         this._viewOwner = null;
      }
      
      private function removeListeners() : void
      {
         this._moveTrait.moveStarted.remove(this.close);
         this._moveTrait.moveStopped.remove(this.open);
         TweenLite.killDelayedCallsTo(this.playClose);
         TweenLite.killDelayedCallsTo(this.playOpen);
      }
      
      private function open() : void
      {
         if(!this._isOpen)
         {
            TweenLite.killDelayedCallsTo(this.playClose);
            TweenLite.killDelayedCallsTo(this.playOpen);
            TweenLite.delayedCall(1,this.playOpen);
            this._isOpen = true;
         }
      }
      
      private function close() : void
      {
         if(this._isOpen)
         {
            TweenLite.killDelayedCallsTo(this.playOpen);
            TweenLite.killDelayedCallsTo(this.playClose);
            TweenLite.delayedCall(1,this.playClose);
         }
         this._isOpen = false;
      }
      
      private function playOpen() : void
      {
         var _loc4_:Drone3D = null;
         this._viewOwner.playAnimation("Open",this.openFinish);
         if(this._viewOwner.drones == null)
         {
            return;
         }
         var _loc1_:Vector.<Drone3D> = this._viewOwner.drones.drones;
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._viewOwner.drones.drones[_loc3_];
            _loc4_.view.playAnimation("Open");
            _loc3_++;
         }
      }
      
      private function openFinish() : void
      {
         this._viewOwner.playAnimation("idle");
      }
      
      private function playClose() : void
      {
         var _loc4_:Drone3D = null;
         this._viewOwner.playAnimation("Close");
         if(this._viewOwner.drones == null)
         {
            return;
         }
         var _loc1_:Vector.<Drone3D> = this._viewOwner.drones.drones;
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._viewOwner.drones.drones[_loc3_];
            _loc4_.view.playAnimation("Close");
            _loc3_++;
         }
      }
   }
}

