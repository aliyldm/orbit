package net.bigpoint.darkorbit.map.hud.ship
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.ShipUpgradesTrait;
   
   public class ShipUpgradeDisplay extends Sprite implements IDisposable
   {
      
      private var _hGroup:HorizontalGroup = new HorizontalGroup();
      
      private var _shipUpgradesDisplay:Vector.<DisplayObject>;
      
      private var _trait:ShipUpgradesTrait;
      
      private var _attackTargetTrait:AttackTargetTrait;
      
      public function ShipUpgradeDisplay(param1:ShipUpgradesTrait)
      {
         super();
         addChild(this._hGroup);
         this._hGroup.gap = 1;
         this._hGroup.redrawNextFrame = false;
         this._trait = param1;
         this._attackTargetTrait = this._trait.owner.getFirstTrait(AttackTargetTrait) as AttackTargetTrait;
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
            this.visible = param1 == this._attackTargetTrait.owner || _loc2_.isHeroShip() || _loc2_ is Pet && (_loc2_ as Pet).isHeroPet();
         }
         else if(this._attackTargetTrait != null)
         {
            this.visible = param1 == this._attackTargetTrait.owner;
         }
      }
      
      private function update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:SWFFinisher = null;
         var _loc4_:Bitmap = null;
         if(visible)
         {
            this._shipUpgradesDisplay = new Vector.<DisplayObject>();
            _loc1_ = 0;
            while(_loc1_ < this._trait._shipUpgrades.length)
            {
               _loc2_ = InGameCatalog.instance.getShipModuleIcon(int(this._trait._shipUpgrades.getElementAt(_loc1_)));
               _loc3_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("icons"));
               _loc4_ = new Bitmap();
               _loc4_.bitmapData = _loc3_.getEmbeddedBitmapData(_loc2_);
               this._shipUpgradesDisplay.push(_loc4_);
               _loc1_++;
            }
            this._hGroup.setElements(this._shipUpgradesDisplay);
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this._trait.changed.remove(this.update);
      }
      
      override public function set visible(param1:Boolean) : void
      {
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

