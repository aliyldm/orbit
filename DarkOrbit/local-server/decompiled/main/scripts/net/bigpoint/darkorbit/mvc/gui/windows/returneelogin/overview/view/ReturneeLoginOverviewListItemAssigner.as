package net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.overview.view
{
   import com.bigpoint.utils.TextFormatter;
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class ReturneeLoginOverviewListItemAssigner extends DefaultItemDataAssigner
   {
      
      private var _icon:Coreponent;
      
      private var _amount:Label;
      
      public function ReturneeLoginOverviewListItemAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._icon = FuiComponentSelectorUtil.selectComponent("icon",this) as Coreponent;
         this._amount = FuiComponentSelectorUtil.selectComponent("amount",this) as Label;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:ItemVO = null;
         _loc2_ = param1 as ItemVO;
         if(!_loc2_)
         {
            visible = false;
            return;
         }
         this.removeListeners();
         super.data = _loc2_;
         this.addListeners();
         loadResource(_loc2_.getLoot100x100(),this.handleItemIconLoaded,this.handleItemIconLoadError,AssetsProxy.ITEMS);
         this._amount.text = _loc2_.amount > 1 ? "x" + TextFormatter.roundInteger(_loc2_.amount) : "";
         tooltipData = _loc2_.fullname + "\n\n" + _loc2_.descriptionName;
      }
      
      private function addListeners() : void
      {
      }
      
      private function removeListeners() : void
      {
      }
      
      private function handleItemIconLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._icon);
         var _loc2_:* = new Bitmap(param1.getBitmap().bitmapData);
         _loc2_.width = this._icon.width;
         _loc2_.height = this._icon.height;
         this._icon.addChild(_loc2_);
      }
      
      private function handleItemIconLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._icon);
      }
      
      public function get VO() : ItemVO
      {
         return data as ItemVO;
      }
   }
}

