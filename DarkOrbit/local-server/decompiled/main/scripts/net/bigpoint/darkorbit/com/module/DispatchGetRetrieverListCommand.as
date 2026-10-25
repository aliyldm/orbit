package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DispatchGetRetrieverListCommand implements IModule
   {
      
      private static var _instance:DispatchGetRetrieverListCommand;
      
      public static const STATUSTYPE_AVAILABLE:int = 0;
      
      public static const STATUSTYPE_IN_PROGRESS:int = 1;
      
      public static const STATUSTYPE__MAX:int = 2;
      
      public var statusType:int = 0;
      
      public var retrieverList:Vector.<DispatchModule>;
      
      public function DispatchGetRetrieverListCommand(param1:int = 0, param2:Vector.<DispatchModule> = null)
      {
         super();
         this.statusType = param1;
         if(param2 == null)
         {
            this.retrieverList = new Vector.<DispatchModule>();
         }
         else
         {
            this.retrieverList = param2;
         }
      }
      
      public static function get instance() : DispatchGetRetrieverListCommand
      {
         return _instance || (_instance = new DispatchGetRetrieverListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 28793;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:DispatchModule = null;
         this.statusType = param1.readShort();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.retrieverList.length > 0)
         {
            this.retrieverList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = DispatchModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.retrieverList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:DispatchModule = null;
         param1.writeShort(28793);
         param1.writeShort(this.statusType);
         param1.writeByte(this.retrieverList.length);
         for each(_loc2_ in this.retrieverList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

