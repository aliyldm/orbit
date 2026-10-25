package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DispatchGetGateListCommand implements IModule
   {
      
      private static var _instance:DispatchGetGateListCommand;
      
      public var gateList:Vector.<DispatchGateModule>;
      
      public function DispatchGetGateListCommand(param1:Vector.<DispatchGateModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.gateList = new Vector.<DispatchGateModule>();
         }
         else
         {
            this.gateList = param1;
         }
      }
      
      public static function get instance() : DispatchGetGateListCommand
      {
         return _instance || (_instance = new DispatchGetGateListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -17811;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:DispatchGateModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.gateList.length > 0)
         {
            this.gateList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = DispatchGateModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.gateList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:DispatchGateModule = null;
         param1.writeShort(-17811);
         param1.writeByte(this.gateList.length);
         for each(_loc2_ in this.gateList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

