package net.bigpoint.darkorbit.map.hud.ship
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.drones.Drones;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.map.model.traits.HPTrait;
   import net.bigpoint.darkorbit.map.model.traits.ShipUpgradesTrait;
   import net.bigpoint.darkorbit.map.model.traits.hud.IconTrait;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class TopDisplay extends Sprite implements IDisposable
   {
      
      private var _owner:MapEntity;
      
      private var _cacheStaticText:Boolean;
      
      private var _container:Sprite = new Sprite();
      
      private var _droneBitmap:Bitmap = new Bitmap();
      
      private var _droneSimpleDisplay:TextField = new TextField();
      
      private var _additionContainer:HorizontalGroup = new HorizontalGroup();
      
      private var _healthInfoDisplay:HealthInfoDisplay;
      
      private var _drones:Drones;
      
      private var _shipUpgradeDisplay:ShipUpgradeDisplay;
      
      public function TopDisplay(param1:MapEntity, param2:Boolean = false)
      {
         super();
         this._cacheStaticText = param2;
         this._owner = param1;
         this._additionContainer.alignment = HorizontalGroup.BOTTOM;
         this._additionContainer.childLayout = HorizontalGroup.CENTER;
         this._additionContainer.gap = 5;
         this._container.addChild(this._droneBitmap);
         addChild(this._additionContainer);
         if(this.hp)
         {
            this._healthInfoDisplay = new HealthInfoDisplay(this.hp);
            this._container.addChild(this._healthInfoDisplay);
            this.hp.changed.add(this.updateLayout);
         }
         if(this.shipUpgrades)
         {
            this._shipUpgradeDisplay = new ShipUpgradeDisplay(this.shipUpgrades);
            this._container.addChild(this._shipUpgradeDisplay);
            this.shipUpgrades.changed.add(this.updateLayout);
         }
         addChild(this._container);
         this._owner.traitAdded.add(this.markDirty);
         this._owner.traitRemoved.add(this.markDirty);
         if(this._owner is Ship)
         {
            this._drones = Ship(this._owner).drones;
            this._drones.droneFormationId.changed.add(this.markDirty);
            this._drones.simpleDroneRepresentation.changed.add(this.markDirty);
            this._drones.visible.changed.add(this.markDirty);
            Settings.showDrones.changed.add(this.markDirty);
            Settings.showMyDrones.changed.add(this.markDirty);
         }
         this.redraw();
      }
      
      private function get hp() : HPTrait
      {
         return this._owner.getFirstTrait(HPTrait) as HPTrait;
      }
      
      private function get shipUpgrades() : ShipUpgradesTrait
      {
         return this._owner.getFirstTrait(ShipUpgradesTrait) as ShipUpgradesTrait;
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._drones)
         {
            this._drones.simpleDroneRepresentation.changed.remove(this.markDirty);
            this._drones.droneFormationId.changed.remove(this.markDirty);
            this._drones.visible.changed.remove(this.markDirty);
            Settings.showDrones.changed.remove(this.markDirty);
            Settings.showMyDrones.changed.remove(this.markDirty);
         }
         if(this.hp)
         {
            this.hp.changed.remove(this.updateLayout);
         }
         if(this._healthInfoDisplay)
         {
            this._healthInfoDisplay.disposeView();
         }
         if(this.shipUpgrades)
         {
            this.shipUpgrades.changed.remove(this.updateLayout);
         }
         if(this._shipUpgradeDisplay)
         {
            this._shipUpgradeDisplay.disposeView();
         }
         this._owner.traitAdded.remove(this.markDirty);
         this._owner.traitRemoved.remove(this.markDirty);
      }
      
      private function markDirty(... rest) : void
      {
         if(hasEventListener(Event.ENTER_FRAME))
         {
            return;
         }
         addEventListener(Event.ENTER_FRAME,this.listener);
      }
      
      private function listener(param1:Event) : void
      {
         this.redraw();
      }
      
      public function redraw() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.listener);
         this.updateAdditions();
         this.updateDroneFormation();
         this.updateDroneSimpleRep();
         this.updateLayout();
      }
      
      private function updateLayout() : void
      {
         this._additionContainer.y = -40;
         this._droneBitmap.y = -this._droneBitmap.height;
         this._droneSimpleDisplay.x = 0;
         this._droneSimpleDisplay.y = 0;
         if(Boolean(this._healthInfoDisplay) && this._healthInfoDisplay.visible)
         {
            this._additionContainer.y -= -10;
            this._healthInfoDisplay.x = this._droneBitmap.width + 5;
            this._healthInfoDisplay.y = -18;
            if(this._shipUpgradeDisplay)
            {
               this._shipUpgradeDisplay.x = this._healthInfoDisplay.x;
               this._shipUpgradeDisplay.y = this._healthInfoDisplay.y - 5;
            }
            this._droneSimpleDisplay.x = this._healthInfoDisplay.x + this._healthInfoDisplay.width / 2 - this._droneSimpleDisplay.width / 2;
            this._droneSimpleDisplay.y = this._healthInfoDisplay.y + this._healthInfoDisplay.height + 3;
            if(this._owner is Pet)
            {
               this._healthInfoDisplay.y -= 15;
            }
         }
         else
         {
            this._droneSimpleDisplay.y = -12;
            this._droneSimpleDisplay.x = this._droneBitmap.width;
         }
         this._container.x = -this._container.width * 0.5;
      }
      
      private function updateDroneSimpleRep() : void
      {
         if(this._drones == null || this._drones.visible.value == false || this._owner is Ship && (Ship(this._owner).isHeroShip() ? Settings.showMyDrones.value : Settings.showDrones.value))
         {
            MovieClipUtils.removeDisplayObject(this._droneSimpleDisplay);
         }
         else
         {
            this._droneSimpleDisplay.defaultTextFormat = Styles.alternateDroneFmt;
            this._droneSimpleDisplay.embedFonts = Styles.alternateDroneEmbed;
            this._droneSimpleDisplay.antiAliasType = AntiAliasType.ADVANCED;
            this._droneSimpleDisplay.autoSize = TextFieldAutoSize.LEFT;
            this._droneSimpleDisplay.htmlText = this._drones.simpleDroneRepresentation.value;
            StaticHUDTextCache.configure(this._droneSimpleDisplay,this._cacheStaticText);
            this._container.addChild(this._droneSimpleDisplay);
         }
      }
      
      private function updateDroneFormation() : void
      {
         var _loc1_:String = null;
         var _loc2_:SWFFinisher = null;
         if(Boolean(this._drones) && this._drones.drones.length > 0)
         {
            _loc1_ = InGameCatalog.instance.drone_formations_icons[this._drones.droneFormationId.value];
            _loc2_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("icons"));
            this._droneBitmap.bitmapData = _loc2_.getEmbeddedBitmapData(_loc1_);
         }
         else
         {
            this._droneBitmap.bitmapData = null;
         }
      }
      
      private function updateAdditions() : void
      {
         var _loc5_:AbstractIconView = null;
         var _loc1_:Vector.<DisplayObject> = this._additionContainer.elements;
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            (_loc1_[_loc3_] as AbstractIconView).sizeChanged.remove(this._additionContainer.updateLayout);
            _loc3_++;
         }
         var _loc4_:Vector.<IconTrait> = Vector.<IconTrait>(this._owner.getTraits(IconTrait));
         _loc2_ = int(_loc4_.length);
         this._additionContainer.reset();
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc5_ = this.buildObject(_loc4_[_loc3_] as IconTrait);
            _loc5_.sizeChanged.add(this._additionContainer.updateLayout);
            this._additionContainer.addElement(_loc5_);
            _loc3_++;
         }
      }
      
      private function buildObject(param1:IconTrait) : AbstractIconView
      {
         return Builder.buildObject(param1);
      }
   }
}

import avmplus.getQualifiedClassName;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import net.bigpoint.darkorbit.map.hud.ship.AbstractIconView;
import net.bigpoint.darkorbit.map.hud.ship.DamageIconView;
import net.bigpoint.darkorbit.map.hud.ship.IconView;
import net.bigpoint.darkorbit.map.hud.ship.ScoremageddonIconView;
import net.bigpoint.darkorbit.map.hud.ship.TimerIconView;
import net.bigpoint.darkorbit.map.model.traits.hud.DamageIconTrait;
import net.bigpoint.darkorbit.map.model.traits.hud.IconTrait;
import net.bigpoint.darkorbit.map.model.traits.hud.ScoremageddonIconTrait;
import net.bigpoint.darkorbit.map.model.traits.hud.TimerIconTrait;
import org.as3commons.lang.ClassUtils;

class Builder
{
   
   private static const MAPPING:Dictionary = new Dictionary();
   
   MAPPING[ClassUtils.getFullyQualifiedName(IconTrait)] = IconView;
   MAPPING[ClassUtils.getFullyQualifiedName(ScoremageddonIconTrait)] = ScoremageddonIconView;
   MAPPING[ClassUtils.getFullyQualifiedName(DamageIconTrait)] = DamageIconView;
   MAPPING[ClassUtils.getFullyQualifiedName(TimerIconTrait)] = TimerIconView;
   
   public function Builder()
   {
      super();
   }
   
   public static function buildObject(param1:IconTrait) : AbstractIconView
   {
      return new MAPPING[getQualifiedClassName(param1)](param1);
   }
}
