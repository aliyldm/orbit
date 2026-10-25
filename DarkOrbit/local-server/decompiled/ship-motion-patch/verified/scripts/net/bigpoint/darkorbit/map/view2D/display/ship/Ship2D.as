package net.bigpoint.darkorbit.map.view2D.display.ship
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.bindables.BindableRotation;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.ctb.BeaconTrait;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.ILayerChild;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.ship.PodCarrierTrait;
   import net.bigpoint.darkorbit.map.model.ship.PoliceTrait;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.ShipLightTrait;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.map.model.traits.ShipDisplayTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.ShipVisualBudget2D;
   import net.bigpoint.darkorbit.map.view2D.display.ship.decorators.Beacon2D;
   import net.bigpoint.darkorbit.map.view2D.display.ship.decorators.Pod2D;
   import net.bigpoint.darkorbit.map.view2D.display.ship.decorators.PoliceLights2D;
   import net.bigpoint.darkorbit.map.view2D.display.ship.decorators.ShipLight2D;
   import net.bigpoint.darkorbit.map.view2D.display.ship.drones.DronesFormation2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberPivot2D;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class Ship2D extends Sprite implements IUpdatable, ILayerChild, IDisposable
   {
      
      private static const DECORATORS:Dictionary = new Dictionary();
      
      private static var counter:int = 0;
      
      DECORATORS[BeaconTrait] = Beacon2D;
      DECORATORS[PoliceTrait] = PoliceLights2D;
      DECORATORS[ShipLightTrait] = ShipLight2D;
      DECORATORS[PodCarrierTrait] = Pod2D;
      
      private var _requestedVisible:Boolean = true;
      
      private var _petRangeHidden:Boolean = false;
      
      private var _iconAngle:Number = NaN;
      
      private var _trait:ShipDisplayTrait;
      
      private var _trait2decorator:Dictionary = new Dictionary();
      
      private var _floatingOffset:PointLite = new PointLite();
      
      private var _drones:DronesFormation2D;
      
      private var _attacker:AttackerTrait;
      
      private var _pivots:Vector.<UberPivot2D> = new Vector.<UberPivot2D>();
      
      private var _shipClips:Vector.<ShipClip> = new Vector.<ShipClip>();
      
      private var _reduced:Boolean = false;
      
      private var _reducedIcon:Bitmap;
      
      private var _budgetRegistered:Boolean = false;
      
      private var _base:ShipClip;
      
      private var _engines:Engines2D;
      
      public function Ship2D(param1:ShipDisplayTrait)
      {
         var _loc2_:EntityTraitBase = null;
         var _loc3_:XML = null;
         var _loc4_:UberPivot2D = null;
         super();
         this._trait = param1;
         this._base = new ShipClip();
         this._base.rotationSource = this.ship.rotation;
         addChild(this._base);
         this._engines = new Engines2D(this.ship,this._base);
         addChild(this._engines);
         this._drones = new DronesFormation2D(this.ship.drones,this);
         addChild(this._drones);
         if(this.ship.uberDisplayTrait.descriptor.display2D)
         {
            for each(_loc3_ in this.ship.uberDisplayTrait.descriptor.display2D[0].pivot)
            {
               _loc4_ = new UberPivot2D(this.ship.getPivot(_loc3_.@id));
               _loc4_.x = Number(_loc3_.@x) || 0;
               _loc4_.y = Number(_loc3_.@y) || 0;
               this._pivots.push(_loc4_);
            }
         }
         this._attacker = param1.owner.getFirstTrait(AttackerTrait) as AttackerTrait;
         if(this._attacker)
         {
            this._attacker.laser.positionsProvider = new Lasers2D(this.ship,this._base);
         }
         Settings.qualityShip.changed.add(this.updateShipClip);
         this.ship.shipPatternChanged.add(this.updateShipClip);
         this.ship.info.factionID.changed.add(this.updateShipClip);
         this.ship.position.changed.add(this.updatePosition);
         this.ship.cloaked.changed.add(this.handleCloakedChanged);
         Settings.hoverShips.changed.add(this.updateFloating);
         this.ship.traitAdded.add(this.handleTraitAdded);
         this.ship.traitRemoved.add(this.handleTraitRemoved);
         for each(_loc2_ in this.ship.traits)
         {
            this.handleTraitAdded(_loc2_);
         }
         this.updateShipClip();
         this.updatePosition();
         this.handleCloakedChanged();
         this.ship.moveTrait.moveStopped.add(this.startFloating);
         this.ship.moveTrait.moveStarted.add(this.stopFloating);
         if(!this.ship.moveTrait.isMoving)
         {
            this.startFloating();
         }
      }
      
      public static function get2DFiltersByDescriptor(param1:XML) : Array
      {
         var _loc3_:XML = null;
         var _loc4_:GlowFilter = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:Array = [];
         if(param1.glow.length() > 0)
         {
            _loc3_ = param1.glow[0];
            _loc4_ = new GlowFilter();
            if(_loc3_.attribute("color") != null)
            {
               _loc4_.color = int(_loc3_.@color);
            }
            if(_loc3_.attribute("blurX") != null)
            {
               _loc4_.blurX = int(_loc3_.@blurX);
            }
            if(_loc3_.attribute("blurY") != null)
            {
               _loc4_.blurY = int(_loc3_.@blurY);
            }
            if(_loc3_.attribute("inner") != null)
            {
               _loc4_.inner = String(_loc3_.@inner) == "true";
            }
            _loc2_.push(_loc4_);
         }
         if(param1.colorMatrix.length() > 0)
         {
            _loc5_ = param1.child("colorMatrix").attribute("matrix");
            _loc6_ = _loc5_.split(",");
            _loc7_ = int(_loc6_.length);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc6_[_loc8_] = int(_loc6_[_loc8_]);
               _loc8_++;
            }
            _loc2_.push(new ColorMatrixFilter(_loc6_));
         }
         return _loc2_;
      }
      
      override public function get visible() : Boolean
      {
         return super.visible;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         this._requestedVisible = param1;
         super.visible = param1 && !this._petRangeHidden;
      }
      
      public function get base() : ShipClip
      {
         return this._base;
      }
      
      public function get engines() : Engines2D
      {
         return this._engines;
      }
      
      public function get layer() : int
      {
         return this.ship.isHeroShip() ? 3 : 2;
      }
      
      public function get ship() : Ship
      {
         return this._trait.owner as Ship;
      }
      
      private function get shipPattern() : ShipPattern
      {
         return this.ship.shipPattern;
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._budgetRegistered)
         {
            ShipVisualBudget2D.unregister(this);
         }
         MovieClipUtils.removeDisplayObject(this);
         this.removeAllDecorators();
         this._base.disposeView();
         if(this._drones)
         {
            this._drones.disposeView();
         }
         if(this._engines)
         {
            this._engines.disposeView();
         }
         while(this._shipClips.length)
         {
            this._shipClips.pop().disposeView(true);
         }
         Settings.qualityShip.changed.remove(this.updateShipClip);
         TweenMax.killTweensOf(this);
         this.stopFloating();
         if(Boolean(this._attacker) && this._attacker.laser.positionsProvider is Lasers2D)
         {
            Lasers2D(this._attacker.laser.positionsProvider).disposeView();
            this._attacker.laser.positionsProvider = null;
         }
         this.ship.shipPatternChanged.remove(this.updateShipClip);
         this.ship.info.factionID.changed.remove(this.updateShipClip);
         this.ship.position.changed.remove(this.updatePosition);
         this.ship.cloaked.changed.remove(this.handleCloakedChanged);
         this.ship.position.changed.remove(this.updatePosition);
         this.ship.info.factionID.changed.remove(this.updateShipClip);
         this.ship.traitAdded.remove(this.handleTraitAdded);
         this.ship.traitRemoved.remove(this.handleTraitRemoved);
         this.ship.cloaked.changed.remove(this.handleCloakedChanged);
         this.ship.moveTrait.moveStopped.remove(this.startFloating);
         this.ship.moveTrait.moveStarted.remove(this.stopFloating);
      }
      
      public function getDecoratorForTrait(param1:EntityTraitBase) : Object
      {
         return this._trait2decorator[param1];
      }
      
      public function updateObj(param1:Number) : void
      {
         if(!this._budgetRegistered)
         {
            this._budgetRegistered = true;
            ShipVisualBudget2D.register(this);
         }
         if(this._petRangeHidden)
         {
            return;
         }
         if(this._reduced)
         {
            this.updateReducedHeading();
            return;
         }
         if(Boolean(this._drones) && this._drones.active)
         {
            this._drones.updateObj(param1);
         }
         var _loc2_:* = int(this._pivots.length - 1);
         while(_loc2_ >= 0)
         {
            this._pivots[_loc2_].updateObj(param1);
            _loc2_--;
         }
      }
      
      private function removeAllDecorators() : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this._trait2decorator)
         {
            if(_loc1_ is DisplayObject && Boolean(DisplayObject(_loc1_).parent))
            {
               DisplayObject(_loc1_).parent.removeChild(_loc1_ as DisplayObject);
            }
            if(_loc1_ is IDisposable)
            {
               IDisposable(_loc1_).disposeView();
            }
         }
      }
      
      private function handleTraitAdded(param1:EntityTraitBase) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in DECORATORS)
         {
            if(param1 is _loc2_)
            {
               this._trait2decorator[param1] = new DECORATORS[_loc2_](param1,this);
               if(this._trait2decorator[param1] is DisplayObject)
               {
                  addChild(this._trait2decorator[param1]);
                  DisplayObject(this._trait2decorator[param1]).visible = !this._reduced;
               }
            }
         }
      }
      
      private function handleTraitRemoved(param1:EntityTraitBase) : void
      {
         var _loc2_:Object = null;
         if(this._trait2decorator[param1])
         {
            _loc2_ = this._trait2decorator[param1];
            if(_loc2_ is DisplayObject)
            {
               removeChild(_loc2_ as DisplayObject);
            }
            if(_loc2_ is IDisposable)
            {
               IDisposable(_loc2_).disposeView();
            }
         }
      }
      
      private function updateFloating() : void
      {
         if(this._petRangeHidden || this._reduced)
         {
            this.stopFloating();
            return;
         }
         if(!this.ship.moveTrait.isMoving)
         {
            if(Settings.hoverShips.value == false)
            {
               this.stopFloating();
            }
            else
            {
               this.startFloating();
            }
         }
      }
      
      private function stopFloating() : void
      {
         TweenMax.killTweensOf(this._floatingOffset);
         this._floatingOffset.y = 0;
      }
      
      private function startFloating() : void
      {
         if(this._petRangeHidden || this._reduced)
         {
            return;
         }
         if(Settings.hoverShips.value)
         {
            TweenMax.to(this._floatingOffset,1.2,{
               "y":3,
               "repeat":-1,
               "yoyo":true,
               "onUpdate":this.updatePosition
            });
         }
      }
      
      private function updatePosition() : void
      {
         if(this._petRangeHidden)
         {
            return;
         }
         x = int(this.ship.x + this._floatingOffset.x);
         y = int(this.ship.y + this._floatingOffset.y);
      }
      
      private function handleCloakedChanged() : void
      {
         if(this.ship.cloaked.value)
         {
            TweenLite.to(this,0.2,{"alpha":0.3});
         }
         else
         {
            TweenLite.to(this,0.2,{"alpha":1});
         }
      }
      
      private function updateShipClip() : void
      {
         var _loc2_:XML = null;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:XML = null;
         var _loc8_:ShipClip = null;
         var _loc9_:String = null;
         while(this._shipClips.length)
         {
            this._shipClips.pop().disposeView(true);
         }
         var _loc1_:UberDisplayTrait = this._trait.owner.getFirstTrait(UberDisplayTrait) as UberDisplayTrait;
         if(Boolean(_loc1_) && Boolean(_loc1_.descriptor))
         {
            _loc2_ = _loc1_.descriptor.display2D[0];
            _loc3_ = get2DFiltersByDescriptor(_loc2_);
            this._base.filters = _loc3_;
            _loc4_ = _loc2_.@resKey || "mc";
            _loc5_ = _loc2_.@srcKey;
            _loc6_ = String(_loc2_.@replacement) || _loc5_;
            if(Settings.qualityShip.value > Settings.QUALITY_LOW)
            {
               this._base.loadPlaceholder("replacementShips",_loc6_);
               this._base.load(_loc5_,_loc4_,this.shipPattern.rotatable,this.shipPattern.playLoop);
            }
            else
            {
               this._base.load("replacementShips",_loc6_,this.shipPattern.rotatable,this.shipPattern.playLoop);
            }
            if(Settings.qualityShip.value > Settings.QUALITY_LOW)
            {
               for each(_loc7_ in _loc1_.descriptor.display2D[0].shipClip)
               {
                  _loc8_ = new ShipClip();
                  _loc8_.rotationSource = this._petRangeHidden || this._reduced ? null : this.ship.rotation;
                  if(ParserUtility.parseBooleanFromString(_loc7_.@custom))
                  {
                     _loc8_.load(_loc7_.@srcKey,"mc",ParserUtility.parseBooleanFromString(_loc7_.@rotatable),ParserUtility.parseBooleanFromString(_loc7_.@playLoop));
                     _loc9_ = String(_loc7_.@scale);
                     if(_loc9_ != "" && !isNaN(Number(_loc9_)))
                     {
                        _loc8_.scaleX = _loc8_.scaleY = _loc8_.scaleZ = parseFloat(_loc7_.@scale);
                     }
                  }
                  else
                  {
                     _loc8_.load(_loc7_.@srcKey,"mc",this.shipPattern.rotatable,this.shipPattern.playLoop);
                  }
                  if(ParserUtility.parseBooleanFromString(_loc7_.@underShip))
                  {
                     addChildAt(_loc8_,0);
                  }
                  else
                  {
                     addChild(_loc8_);
                  }
                  _loc8_.filters = _loc3_;
                  _loc8_.visible = !this._reduced;
                  this._shipClips.push(_loc8_);
               }
            }
         }
         this.updatePosition();
      }
      
      public function setReducedVisual(param1:Boolean) : Boolean
      {
         var _loc2_:ShipClip = null;
         var _loc3_:Object = null;
         if(this.ship.isHeroShip() || this.ship.isNPC || this.ship is Pet)
         {
            param1 = false;
         }
         if(this._reduced == param1)
         {
            return false;
         }
         if(param1 && !this._reducedIcon)
         {
            this._reducedIcon = ReducedShipIcon2D.create();
            addChild(this._reducedIcon);
         }
         this._reduced = param1;
         this._base.visible = !param1;
         this._base.rotationSource = param1 ? null : this.ship.rotation;
         if(this._reducedIcon)
         {
            this._reducedIcon.visible = param1;
         }
         if(this._engines)
         {
            this._engines.setPresentationEnabled(!param1);
         }
         if(this._drones)
         {
            this._drones.setPresentationEnabled(!param1);
         }
         for each(_loc2_ in this._shipClips)
         {
            _loc2_.visible = !param1;
            _loc2_.rotationSource = param1 ? null : this.ship.rotation;
         }
         for each(_loc3_ in this._trait2decorator)
         {
            if(_loc3_ is DisplayObject)
            {
               DisplayObject(_loc3_).visible = !param1;
            }
         }
         if(param1)
         {
            this.stopFloating();
         }
         else
         {
            this.updateFloating();
         }
         if(param1)
         {
            this.updateReducedHeading();
         }
         return true;
      }
      
      private function updateReducedHeading() : void
      {
         var _loc1_:Number = Math.round(this.ship.rotation.degrees / 3) * 3;
         if(Boolean(this._reducedIcon) && _loc1_ != this._iconAngle)
         {
            this._iconAngle = _loc1_;
            ReducedShipIcon2D.orient(this._reducedIcon,_loc1_);
         }
      }
      
      public function setPetRangeHidden(param1:Boolean) : Boolean
      {
         var _loc2_:ShipClip = null;
         if(!(this.ship is Pet))
         {
            return false;
         }
         if(this._petRangeHidden == param1)
         {
            return false;
         }
         this._petRangeHidden = param1;
         super.visible = this._requestedVisible && !param1;
         this._base.rotationSource = param1 ? null : this.ship.rotation;
         if(this._engines)
         {
            this._engines.setPresentationEnabled(!param1);
         }
         if(this._drones)
         {
            this._drones.setPresentationEnabled(!param1);
         }
         for each(_loc2_ in this._shipClips)
         {
            _loc2_.rotationSource = param1 ? null : this.ship.rotation;
         }
         if(param1)
         {
            this.stopFloating();
         }
         else
         {
            this.updatePosition();
            this.updateFloating();
         }
         return true;
      }
      
      public function get reducedVisual() : Boolean
      {
         return this._reduced;
      }
   }
}

