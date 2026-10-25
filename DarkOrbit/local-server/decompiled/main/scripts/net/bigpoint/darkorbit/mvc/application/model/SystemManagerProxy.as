package net.bigpoint.darkorbit.mvc.application.model
{
   import flash.utils.getTimer;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.application.model.vo.StartupVO;
   import net.bigpoint.darkorbit.mvc.application.model.vo.SystemManagerVO;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class SystemManagerProxy extends Proxy
   {
      
      public static const NAME:String = "SystemManagerProxy";
      
      protected var _systemManagerVO:SystemManagerVO;
      
      protected var _isInitialized:Boolean = false;
      
      protected var _initT:Number;
      
      public function SystemManagerProxy()
      {
         super(NAME);
      }
      
      public function initialize(param1:StartupVO) : void
      {
         var _loc2_:SystemManagerVO = null;
         if(!this._isInitialized)
         {
            _loc2_ = new SystemManagerVO(param1);
            setData(_loc2_);
            this._isInitialized = true;
         }
      }
      
      public function resetInitialTimer() : void
      {
         this._initT = getTimer();
      }
      
      public function isInInitialTimeFrame() : Boolean
      {
         return getTimer() - this._initT < 60000 ? true : false;
      }
      
      public function getSystemVO() : SystemManagerVO
      {
         if(this._systemManagerVO == null)
         {
            this._systemManagerVO = getData() as SystemManagerVO;
         }
         return this._systemManagerVO;
      }
      
      public function get map() : Map
      {
         return this.getSystemVO().screenManager.map;
      }
   }
}

