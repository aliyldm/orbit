package net.bigpoint.darkorbit.com.module.porting.balance
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class BalanceInfoListCommand implements IModule
   {
      
      private static var _instance:BalanceInfoListCommand;
      
      public var page:int = 0;
      
      public var pageCount:int = 0;
      
      public var list:Vector.<BalanceInfoCommand>;
      
      public function BalanceInfoListCommand(param1:int = 0, param2:int = 0, param3:Vector.<BalanceInfoCommand> = null)
      {
         super();
         this.page = param2;
         this.pageCount = param1;
         if(param3 == null)
         {
            this.list = new Vector.<BalanceInfoCommand>();
         }
         else
         {
            this.list = param3;
         }
      }
      
      public static function get instance() : BalanceInfoListCommand
      {
         return _instance || (_instance = new BalanceInfoListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 27806;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:BalanceInfoCommand = null;
         this.page = param1.readInt();
         this.page = this.page << 8 % 32 | this.page >>> 32 - 8 % 32;
         this.pageCount = param1.readInt();
         this.pageCount = this.pageCount >>> 12 % 32 | this.pageCount << 32 - 12 % 32;
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
            _loc4_ = BalanceInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.list.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:BalanceInfoCommand = null;
         param1.writeShort(27806);
         param1.writeInt(this.page >>> 8 % 32 | this.page << 32 - 8 % 32);
         param1.writeInt(this.pageCount << 12 % 32 | this.pageCount >>> 32 - 12 % 32);
         param1.writeByte(this.list.length);
         for each(_loc2_ in this.list)
         {
            _loc2_.write(param1);
         }
      }
   }
}

