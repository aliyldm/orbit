package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.reward.model
{
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   
   public class SpaceSearchMsgAssigner extends DefaultItemDataAssigner
   {
      
      private var icons:Vector.<Coreponent> = new Vector.<Coreponent>();
      
      private var bgs:Vector.<Coreponent> = new Vector.<Coreponent>();
      
      private var labels:Vector.<Label> = new Vector.<Label>();
      
      private var btns:Vector.<Button> = new Vector.<Button>();
      
      public function SpaceSearchMsgAssigner()
      {
         super();
      }
      
      private function get vo() : SpaceSearchListVO
      {
         return data as SpaceSearchListVO;
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.update();
      }
      
      override public function assignChildren() : void
      {
         var _loc2_:Coreponent = null;
         var _loc4_:Coreponent = null;
         var _loc5_:Label = null;
         var _loc6_:Button = null;
         super.assignChildren();
         this.icons.length = 0;
         this.bgs.length = 0;
         this.labels.length = 0;
         this.btns.length = 0;
         var _loc1_:int = 8;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = FuiComponentSelectorUtil.selectComponent("icon" + _loc3_,this) as Coreponent;
            _loc2_.visible = false;
            this.icons.push(_loc2_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc4_ = FuiComponentSelectorUtil.selectComponent("iconBg" + _loc3_,this) as Coreponent;
            _loc4_.visible = false;
            this.bgs.push(_loc4_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc5_ = FuiComponentSelectorUtil.selectComponent("amount" + _loc3_,this) as Label;
            _loc5_.visible = false;
            this.labels.push(_loc5_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc6_ = FuiComponentSelectorUtil.selectComponent("btn" + _loc3_,this) as Button;
            _loc6_.visible = false;
            this.btns.push(_loc6_);
            _loc3_++;
         }
      }
      
      public function setVisible(param1:int, param2:Boolean) : void
      {
         if(this.icons[param1])
         {
            this.icons[param1].visible = param2;
         }
         if(this.bgs[param1])
         {
            this.bgs[param1].visible = param2;
         }
         if(this.labels[param1])
         {
            this.labels[param1].visible = param2;
         }
         if(this.btns[param1])
         {
            this.btns[param1].visible = param2;
         }
      }
      
      public function update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:SSReward = null;
         var _loc3_:ItemVO = null;
         if(!this.vo)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.icons.length)
         {
            this.setVisible(_loc1_,false);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.vo.rewards.length)
         {
            this.setVisible(_loc1_,true);
            _loc2_ = this.vo.rewards[_loc1_];
            _loc3_ = ItemDataProviderHelper.getItem(_loc2_.lootId);
            IconVOLoader.getInstance().loadIcon(this.icons[_loc1_],_loc3_,"100x100",AssetsProxy.ITEMS);
            this.labels[_loc1_].text = _loc2_.amount + "";
            this.btns[_loc1_].tooltipData = _loc3_.fullname;
            _loc1_++;
         }
      }
   }
}

