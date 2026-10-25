package net.bigpoint.darkorbit.map.hud.ship
{
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.HPTrait;
   
   public class HealthInfoDisplay extends Sprite implements IDisposable
   {
      
      private static const BAR_BACKGROUND_OUTLINE:int = 2894892;
      
      private static const BAR_BACKGROUND_COLOR:int = 7105644;
      
      private static const BORDER_SIZE:int = 0.5;
      
      private var shieldDisplay:Shape = new Shape();
      
      private var healthDisplay:Shape = new Shape();
      
      private var nanoHealthDisplay:Shape = new Shape();
      
      private var _vGroup:VerticalGroup = new VerticalGroup();
      
      private var _trait:HPTrait;
      
      private var _attackTargetTrait:AttackTargetTrait;
      
      private var _config:HealthInfoDisplayConfig = new HealthInfoDisplayConfig();
      
      public function HealthInfoDisplay(param1:HPTrait)
      {
         super();
         this._trait = param1;
         this._attackTargetTrait = this._trait.owner.getFirstTrait(AttackTargetTrait) as AttackTargetTrait;
         if(param1.hpBarWidth)
         {
            this._config.width = param1.hpBarWidth;
         }
         addChild(this._vGroup);
         this._vGroup.gap = 2;
         this._vGroup.redrawNextFrame = false;
         this._vGroup.addElement(this.healthDisplay);
         this._vGroup.addElement(this.nanoHealthDisplay);
         this._vGroup.addElement(this.shieldDisplay);
         this.update();
         if(this._attackTargetTrait)
         {
            ScreenManager.getInstance().map.lockManager.targetChanged.add(this.handleLockChanged);
         }
         this._trait.changed.add(this.update);
         this.handleLockChanged(ScreenManager.getInstance().map.lockManager.target);
      }
      
      private function handleLockChanged(param1:MapEntity) : void
      {
         var _loc2_:Ship = this._trait.owner as Ship;
         if(_loc2_)
         {
            this.visible = _loc2_.info.specialType.value == ShipInfoDisplay.PLAYER_CAMP_NPC_TYPE || (param1 == this._attackTargetTrait.owner || _loc2_.isHeroShip() || (_loc2_ is Pet && (_loc2_ as Pet).isHeroPet() || _loc2_.shipPattern.npcId == 240));
         }
         else if(this._attackTargetTrait != null)
         {
            this.visible = param1 == this._attackTargetTrait.owner;
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this._trait.changed.remove(this.update);
         if(this._attackTargetTrait)
         {
            ScreenManager.getInstance().map.lockManager.targetChanged.remove(this.handleLockChanged);
         }
      }
      
      private function update() : void
      {
         var _loc1_:Vector.<DisplayObject> = null;
         if(visible)
         {
            _loc1_ = new Vector.<DisplayObject>();
            if(this._trait.hp.value > 0)
            {
               _loc1_.push(this.healthDisplay);
               this.drawBar(this.healthDisplay,this._config.healthColor,this._trait.hp.value / this._trait.maxHP.value);
            }
            if(this._trait.nanohullHP.value > 0)
            {
               _loc1_.push(this.nanoHealthDisplay);
               this.drawBar(this.nanoHealthDisplay,this._config.nanoHealthColor,this._trait.nanohullHP.value / this._trait.nanohullMaxHP.value);
            }
            if(this._trait.shield.value > 0)
            {
               _loc1_.push(this.shieldDisplay);
               this.drawBar(this.shieldDisplay,this._config.shieldColor,this._trait.shield.value / this._trait.maxShield.value);
            }
            this._vGroup.setElements(_loc1_);
         }
      }
      
      private function drawBar(param1:Shape, param2:uint, param3:Number) : void
      {
         param1.graphics.clear();
         param1.graphics.lineStyle(BORDER_SIZE,BAR_BACKGROUND_OUTLINE,1,true);
         param1.graphics.beginFill(BAR_BACKGROUND_COLOR);
         param1.graphics.drawRect(-BORDER_SIZE,-BORDER_SIZE,this._config.width + 2 * BORDER_SIZE,this._config.height + 2 * BORDER_SIZE);
         param1.graphics.endFill();
         if(!isNaN(param3))
         {
            param1.graphics.beginFill(param2);
            param1.graphics.drawRect(0,0,Math.max(0,Math.min(1,param3)) * this._config.width,this._config.height);
            param1.graphics.endFill();
         }
      }
      
      public function get config() : HealthInfoDisplayConfig
      {
         return this._config;
      }
      
      public function set config(param1:HealthInfoDisplayConfig) : void
      {
         if(this._config)
         {
            this._config.changed.remove(this.update);
         }
         this._config = param1;
         if(this._config)
         {
            this._config.changed.add(this.update);
         }
         this.update();
      }
      
      override public function set visible(param1:Boolean) : void
      {
         var _loc2_:Ship = this._trait.owner as Ship;
         if(_loc2_)
         {
            if(_loc2_.info.specialType.value == ShipInfoDisplay.PLAYER_CAMP_NPC_TYPE)
            {
               param1 = true;
            }
         }
         if(param1 != visible)
         {
            super.visible = param1;
            if(param1)
            {
               this.update();
            }
         }
      }
   }
}

