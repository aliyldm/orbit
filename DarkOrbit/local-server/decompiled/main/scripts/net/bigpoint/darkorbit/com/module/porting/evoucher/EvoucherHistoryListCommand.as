package net.bigpoint.darkorbit.com.module.porting.evoucher
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class EvoucherHistoryListCommand implements IModule
   {
      
      private static var _instance:EvoucherHistoryListCommand;
      
      public var list:Vector.<EvoucherHistoryInfoCommand>;
      
      public function EvoucherHistoryListCommand(param1:Vector.<EvoucherHistoryInfoCommand> = null)
      {
         super();
         if(param1 == null)
         {
            this.list = new Vector.<EvoucherHistoryInfoCommand>();
         }
         else
         {
            this.list = param1;
         }
      }
      
      public static function get instance() : EvoucherHistoryListCommand
      {
         return _instance || (_instance = new EvoucherHistoryListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 30369;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:EvoucherHistoryInfoCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.list.length > 0)
         {
            this.list.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = EvoucherHistoryInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.list.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:EvoucherHistoryInfoCommand = null;
         param1.writeShort(30369);
         param1.writeByte(this.list.length);
         for each(_loc2_ in this.list)
         {
            _loc2_.write(param1);
         }
      }
   }
}

