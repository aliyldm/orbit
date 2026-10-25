package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model
{
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisGroupCommand;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisInventoryCommand;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisInventoryRequest;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisListCommand;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisModuleListCommand;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.vo.SynthesisMockData;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.vo.SynthesisViewData;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.WarpControlsProxy;
   import org.puremvc.as3.multicore.interfaces.IFacade;
   
   public class CannonSynthesisProxy extends SimpleWindowProxy
   {
      
      public static const NAME:String = "CannonSynthesisProxy";
      
      private static const USE_MOCK_DATA:Boolean = false;
      
      private var _allViewData:SynthesisViewData = null;
      
      public function CannonSynthesisProxy()
      {
         super(NAME);
         this._allViewData = new SynthesisViewData();
      }
      
      public static function getProxy(param1:IFacade) : CannonSynthesisProxy
      {
         var _loc2_:CannonSynthesisProxy = param1.retrieveProxy(CannonSynthesisProxy.NAME) as CannonSynthesisProxy;
         if(!_loc2_)
         {
            _loc2_ = new CannonSynthesisProxy();
            param1.registerProxy(_loc2_);
         }
         return _loc2_;
      }
      
      public function get viewData() : SynthesisViewData
      {
         return this._allViewData;
      }
      
      public function sendInitInventoryRequest() : void
      {
         var _loc2_:SynthesisMockData = null;
         var _loc3_:SynthesisListCommand = null;
         var _loc4_:SynthesisInventoryCommand = null;
         if(USE_MOCK_DATA)
         {
            _loc2_ = SynthesisMockData.getInstance();
            _loc3_ = _loc2_.createListCommand();
            _loc4_ = _loc2_.createInventoryCommand();
            this.rcvInitRequest(_loc3_);
            this.rcvInventoryRequest(_loc4_);
            return;
         }
         var _loc1_:SynthesisInventoryRequest = new SynthesisInventoryRequest();
         connectionProxy.connectionManager.sendRequest(_loc1_);
      }
      
      public function rcvInitRequest(param1:SynthesisListCommand) : void
      {
         this._allViewData.setData(param1);
      }
      
      public function rcvInventoryRequest(param1:SynthesisInventoryCommand) : void
      {
         if(param1)
         {
            WarpControlsProxy.getProxy(GameFacade.getInstance()).updateInventoryItems(param1.equipmentInventoryItems,param1.remove);
            this._allViewData.updateInventoryItems(param1.equipmentInventoryItems,param1.remove);
         }
      }
      
      private function countModules(param1:SynthesisListCommand) : int
      {
         var _loc3_:SynthesisGroupCommand = null;
         var _loc4_:SynthesisModuleListCommand = null;
         var _loc2_:int = 0;
         if(!param1 || !param1.groups)
         {
            return _loc2_;
         }
         for each(_loc3_ in param1.groups)
         {
            if(!(!_loc3_ || !_loc3_.moduleList))
            {
               for each(_loc4_ in _loc3_.moduleList)
               {
                  if(Boolean(_loc4_) && Boolean(_loc4_.modules))
                  {
                     _loc2_ += _loc4_.modules.length;
                  }
               }
            }
         }
         return _loc2_;
      }
   }
}

