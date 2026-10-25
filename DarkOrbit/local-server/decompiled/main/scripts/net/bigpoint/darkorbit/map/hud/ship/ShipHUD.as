package net.bigpoint.darkorbit.map.hud.ship
{
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.ReadyRequest;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.ILayerChild;
   import net.bigpoint.darkorbit.map.hud.AbstractHUDElement;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.map.model.traits.LocatorGearTrait;
   import net.bigpoint.darkorbit.map.model.traits.MouseHitAreaTrait;
   import net.bigpoint.darkorbit.map.model.traits.hud.MapObjectInfoTrait;
   import net.bigpoint.darkorbit.map.view2D.ShipVisualBudget2D;
   import net.bigpoint.darkorbit.settings.CrowdedCombatPreset;
   import net.bigpoint.darkorbit.settings.CrowdedNameplateCuller;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class ShipHUD extends AbstractHUDElement implements ILayerChild
   {
      
      private static const MAPPING:Dictionary = new Dictionary();
      
      MAPPING[LocatorGearTrait] = LocatorGearView;
      
      private var _entity:MapEntity;
      
      private var _trait2view:Dictionary = new Dictionary();
      
      private var _shipInfoDisplay:ShipInfoDisplay;
      
      private var _topDisplay:TopDisplay;
      
      private var _lastClickRadius:Number = NaN;
      
      private var _lastZoom:Number = NaN;
      
      private var _range2D:Boolean;
      
      private var _rangeHidden:Boolean;
      
      private var _visibleBeforeRange:Boolean;
      
      private var _lastIsHero:Boolean;
      
      private var _culledByCrowding:Boolean = false;
      
      public function ShipHUD(param1:IMapView, param2:MapObjectInfoTrait)
      {
         super(param1,param2.owner.position);
         this._entity = param2.owner;
         var _loc3_:Boolean = param1.readyRequestType == ReadyRequest.READYMESSAGE_MAP_LOADED_3D || param1.readyRequestType == ReadyRequest.READYMESSAGE_MAP_LOADED_2D;
         this._shipInfoDisplay = new ShipInfoDisplay(param2,_loc3_);
         addChild(this._shipInfoDisplay);
         this._topDisplay = new TopDisplay(this._entity,_loc3_);
         addChild(this._topDisplay);
         this._entity.traitAdded.add(this.traitAdded);
         this._entity.traitRemoved.add(this.traitRemoved);
         this.updateLayout();
         this._range2D = param1.readyRequestType == ReadyRequest.READYMESSAGE_MAP_LOADED_2D;
      }
      
      override public function updateObj(param1:Number) : void
      {
         var _loc2_:Ship = null;
         var _loc3_:Boolean = false;
         if(this._range2D && this._entity is Ship)
         {
            _loc2_ = this._entity as Ship;
            _loc3_ = _loc2_ is Pet ? ShipVisualBudget2D.isPetHidden(_loc2_) : ShipVisualBudget2D.isReduced(_loc2_);
            if(_loc3_ != this._rangeHidden)
            {
               if(_loc3_)
               {
                  this._visibleBeforeRange = visible;
                  visible = false;
               }
               else
               {
                  visible = this._visibleBeforeRange;
               }
               this._rangeHidden = _loc3_;
            }
            if(_loc3_)
            {
               return;
            }
         }
         super.updateObj(param1);
         this.updateCrowdedCulling();
         this.updateLayout();
      }
      
      private function updateCrowdedCulling() : void
      {
         var _loc1_:Ship = this._entity as Ship;
         if(CrowdedNameplateCuller.shouldShowNameplate(_loc1_))
         {
            if(this._culledByCrowding)
            {
               this._culledByCrowding = false;
               if(Settings.displayPlayerNames.value)
               {
                  this._shipInfoDisplay.visible = true;
               }
            }
         }
         else if(!this._culledByCrowding)
         {
            this._culledByCrowding = true;
            this._shipInfoDisplay.visible = false;
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         this._entity.traitAdded.remove(this.traitAdded);
         this._entity.traitRemoved.remove(this.traitRemoved);
         this._shipInfoDisplay.disposeView(param1);
         this._topDisplay.disposeView(param1);
         super.disposeView(param1);
      }
      
      private function updateLayout() : void
      {
         var _loc1_:MouseHitAreaTrait = null;
         var _loc2_:Boolean = false;
         var _loc3_:Number = NaN;
         _loc1_ = this._entity ? this._entity.getFirstTrait(MouseHitAreaTrait) as MouseHitAreaTrait : null;
         if(_loc1_)
         {
            _loc2_ = this._entity.id == Hero.userID;
            if(CrowdedCombatPreset.enabled && this._lastClickRadius == _loc1_.clickRadius && this._lastZoom == _zoom && this._lastIsHero == _loc2_)
            {
               return;
            }
            this._lastClickRadius = _loc1_.clickRadius;
            this._lastZoom = _zoom;
            this._lastIsHero = _loc2_;
            _loc3_ = _loc2_ ? _zoom : 1;
            this._shipInfoDisplay.y = _loc1_.clickRadius * _loc3_;
            this._topDisplay.y = -(_loc1_.clickRadius * _loc3_) - 5;
         }
      }
      
      private function traitAdded(param1:EntityTraitBase) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Object = null;
         for(_loc2_ in MAPPING)
         {
            if(param1 is _loc2_)
            {
               _loc3_ = this._trait2view[param1] = new MAPPING[_loc2_](param1,this);
               addChild(_loc3_ as DisplayObject);
            }
         }
         this.updateLayout();
      }
      
      private function traitRemoved(param1:EntityTraitBase) : void
      {
         var _loc2_:Object = this._trait2view[param1];
         if(_loc2_ != null)
         {
            if(_loc2_ is DisplayObject)
            {
               removeChild(_loc2_ as DisplayObject);
            }
            if(_loc2_ is IDisposable)
            {
               (_loc2_ as IDisposable).disposeView();
            }
         }
      }
      
      public function get layer() : int
      {
         return 0;
      }
   }
}

