package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TradeSellOreRequest implements IModule
   {
      
      private static var _instance:TradeSellOreRequest;
      
      public var toSell:OreCountModule;
      
      public function TradeSellOreRequest(param1:OreCountModule = null)
      {
         super();
         if(param1 == null)
         {
            this.toSell = new OreCountModule();
         }
         else
         {
            this.toSell = param1;
         }
      }
      
      public static function get instance() : TradeSellOreRequest
      {
         return _instance || (_instance = new TradeSellOreRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 131;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.toSell = OreCountModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.toSell)
         {
            this.toSell.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(131);
         if(null != this.toSell)
         {
            this.toSell.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

