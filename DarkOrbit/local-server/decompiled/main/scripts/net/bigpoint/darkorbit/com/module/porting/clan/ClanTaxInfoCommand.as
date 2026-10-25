package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class ClanTaxInfoCommand implements IModule
   {
      
      private static var _instance:ClanTaxInfoCommand;
      
      public var income:int = 0;
      
      public var logList:Vector.<ClanTaxLogCommand>;
      
      public function ClanTaxInfoCommand(param1:int = 0, param2:Vector.<ClanTaxLogCommand> = null)
      {
         super();
         this.income = param1;
         if(param2 == null)
         {
            this.logList = new Vector.<ClanTaxLogCommand>();
         }
         else
         {
            this.logList = param2;
         }
      }
      
      public static function get instance() : ClanTaxInfoCommand
      {
         return _instance || (_instance = new ClanTaxInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 629;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ClanTaxLogCommand = null;
         this.income = param1.readInt();
         this.income = this.income << 10 % 32 | this.income >>> 32 - 10 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.logList.length > 0)
         {
            this.logList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ClanTaxLogCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.logList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ClanTaxLogCommand = null;
         param1.writeShort(629);
         param1.writeInt(this.income >>> 10 % 32 | this.income << 32 - 10 % 32);
         param1.writeByte(this.logList.length);
         for each(_loc2_ in this.logList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

