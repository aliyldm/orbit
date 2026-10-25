package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollContainer;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.items.item.attributes.ShipAttributes;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo.RogueLiteShipEquipmentVO;
   
   public class RogueLiteShipEquipmentView implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _shipAttributes:ShipAttributes;
      
      private var _equipmentVO:RogueLiteShipEquipmentVO;
      
      private var _view:Coreponent;
      
      private var _content:Coreponent;
      
      private var _scrollbinder:RogueLiteScrollBinder;
      
      private var _hp:Label;
      
      private var _shield:Label;
      
      private var _shieldspread:Label;
      
      private var _maxspeed:Label;
      
      private var _lasers:RogueLiteItemCollectionView;
      
      private var _generators:RogueLiteItemCollectionView;
      
      private var _modules:RogueLiteItemCollectionView;
      
      private var _cpus:RogueLiteItemCollectionView;
      
      private var _techs:RogueLiteItemCollectionView;
      
      public function RogueLiteShipEquipmentView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("ship") as Coreponent;
         this.init();
      }
      
      public function get title() : String
      {
         return BPLocale.getItemInCategory("inventory","label_tab_ship");
      }
      
      public function get view() : Coreponent
      {
         return this._view;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._view.visible = param1;
      }
      
      public function get visible() : Boolean
      {
         return this._view.visible;
      }
      
      public function set active(param1:Boolean) : void
      {
      }
      
      public function get active() : Boolean
      {
         return true;
      }
      
      public function set shipAttributes(param1:ShipAttributes) : void
      {
         this._shipAttributes = param1;
         this._lasers.slots = this._shipAttributes.maxLaser;
         this._generators.slots = this._shipAttributes.maxGen;
         this._modules.slots = this._shipAttributes.maxSpecials;
      }
      
      public function set hp(param1:int) : void
      {
         this._hp.text = param1.toString();
      }
      
      public function set shield(param1:int) : void
      {
         this._shield.text = param1.toString();
      }
      
      public function set spread(param1:int) : void
      {
         this._shieldspread.text = param1.toString() + "/" + (100 - param1).toString();
      }
      
      public function set speed(param1:int) : void
      {
         this._maxspeed.text = param1.toString();
      }
      
      public function set equipments(param1:RogueLiteShipEquipmentVO) : void
      {
         if(this._equipmentVO)
         {
            this._equipmentVO.lasersChanged.remove(this.updateLasers);
            this._equipmentVO.generatorsChanged.remove(this.updateGenerators);
            this._equipmentVO.cpusChanged.remove(this.updateCpus);
         }
         this._equipmentVO = param1;
         if(this._equipmentVO)
         {
            this._equipmentVO.lasersChanged.add(this.updateLasers);
            this._equipmentVO.generatorsChanged.add(this.updateGenerators);
            this._equipmentVO.cpusChanged.add(this.updateCpus);
            this._lasers.update(this._equipmentVO.lasers);
            this._generators.update(this._equipmentVO.generators);
            this._cpus.update(this._equipmentVO.cpus);
            this.repositionLayout();
         }
      }
      
      private function init() : void
      {
         this._content = this._cache.selectComponent("ship.attributes.content") as Coreponent;
         var _loc1_:Scrollbar = this._cache.selectComponent("ship.ship_scrollBar") as Scrollbar;
         var _loc2_:ScrollContainer = this._cache.selectComponent("ship.attributes") as ScrollContainer;
         this._scrollbinder = new RogueLiteScrollBinder(_loc1_,_loc2_);
         this._lasers = new RogueLiteItemCollectionView(FuiComponentSelectorUtil.selectComponent("laser_section",this._content) as Container);
         this._generators = new RogueLiteItemCollectionView(FuiComponentSelectorUtil.selectComponent("generator_section",this._content) as Container);
         this._modules = new RogueLiteItemCollectionView(FuiComponentSelectorUtil.selectComponent("module_section",this._content) as Container);
         this._cpus = new RogueLiteItemCollectionView(FuiComponentSelectorUtil.selectComponent("cpu_section",this._content) as Container);
         this._techs = new RogueLiteItemCollectionView(FuiComponentSelectorUtil.selectComponent("tech_section",this._content) as Container);
         this._hp = FuiComponentSelectorUtil.selectComponent("hp",this._content) as Label;
         this._shield = FuiComponentSelectorUtil.selectComponent("shield",this._content) as Label;
         this._shieldspread = FuiComponentSelectorUtil.selectComponent("shieldspread",this._content) as Label;
         this._maxspeed = FuiComponentSelectorUtil.selectComponent("maxspeed",this._content) as Label;
         this._lasers.init();
         this._generators.init();
         this._modules.init();
         this._cpus.init();
         this._techs.init();
      }
      
      private function updateLasers(param1:Vector.<ItemVO>) : void
      {
         this._lasers.update(param1);
         this.repositionLayout();
      }
      
      private function updateGenerators(param1:Vector.<ItemVO>) : void
      {
         this._generators.update(param1);
         this.repositionLayout();
      }
      
      private function updateCpus(param1:Vector.<ItemVO>) : void
      {
         this._cpus.update(param1);
         this.repositionLayout();
      }
      
      private function updateTechs(param1:Vector.<ItemVO>) : void
      {
         this._techs.update(param1);
         this.repositionLayout();
      }
      
      private function repositionLayout() : void
      {
         this._generators.marginTop = this._lasers.marginTop + this._lasers.height;
         this._modules.marginTop = this._generators.marginTop + this._generators.height;
         this._cpus.marginTop = this._modules.marginTop + this._modules.height;
         this._content.height = this._cpus.marginTop + this._cpus.height;
      }
   }
}

