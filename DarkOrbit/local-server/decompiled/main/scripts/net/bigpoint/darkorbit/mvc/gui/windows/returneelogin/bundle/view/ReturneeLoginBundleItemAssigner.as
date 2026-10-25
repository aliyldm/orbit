package net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.bundle.view
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.bundle.model.ReturneeLoginBundleData;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class ReturneeLoginBundleItemAssigner extends DefaultItemDataAssigner
   {
      
      private var _icon:Coreponent;
      
      private var _header:Label;
      
      private var _subheader:Label;
      
      private var _payment:Label;
      
      public function ReturneeLoginBundleItemAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._icon = FuiComponentSelectorUtil.selectComponent("icon",this) as Coreponent;
         this._header = FuiComponentSelectorUtil.selectComponent("header",this) as Label;
         this._subheader = FuiComponentSelectorUtil.selectComponent("subheader",this) as Label;
         this._payment = FuiComponentSelectorUtil.selectComponent("payment",this) as Label;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:String = param1 as String;
         if(!_loc2_ || _loc2_.length == 0)
         {
            visible = false;
            return;
         }
         this.removeListeners();
         super.data = _loc2_;
         this.addListeners();
         this._header.text = BPLocale.getItemInCategory("items",ReturneeLoginBundleData.PREFIX + _loc2_ + "_fullname");
         this._subheader.text = BPLocale.getItemInCategory("items",ReturneeLoginBundleData.PREFIX + _loc2_ + "_short");
         this._payment.text = BPLocale.getItemInCategory("items","items_deal_proxiumBooster_short");
         loadResource(_loc2_ + "_100x100",this.handleItemIconLoaded,this.handleItemIconLoadError,AssetsProxy.ITEMS);
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
   }
}

