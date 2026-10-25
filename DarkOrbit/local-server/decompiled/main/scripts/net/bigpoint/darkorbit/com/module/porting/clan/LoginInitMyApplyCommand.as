package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class LoginInitMyApplyCommand implements IModule
   {
      
      private static var _instance:LoginInitMyApplyCommand;
      
      public var applyClanList:Vector.<ClanInfoCommand>;
      
      public var foundCost:int = 0;
      
      public var companyDateInfoCommand:CompanyDateInfoCommand;
      
      public var rejectApplyClanList:Vector.<int>;
      
      public function LoginInitMyApplyCommand(param1:Vector.<ClanInfoCommand> = null, param2:Vector.<int> = null, param3:int = 0, param4:CompanyDateInfoCommand = null)
      {
         super();
         if(param1 == null)
         {
            this.applyClanList = new Vector.<ClanInfoCommand>();
         }
         else
         {
            this.applyClanList = param1;
         }
         this.foundCost = param3;
         if(param4 == null)
         {
            this.companyDateInfoCommand = new CompanyDateInfoCommand();
         }
         else
         {
            this.companyDateInfoCommand = param4;
         }
         if(param2 == null)
         {
            this.rejectApplyClanList = new Vector.<int>();
         }
         else
         {
            this.rejectApplyClanList = param2;
         }
      }
      
      public static function get instance() : LoginInitMyApplyCommand
      {
         return _instance || (_instance = new LoginInitMyApplyCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -13451;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ClanInfoCommand = null;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.applyClanList.length > 0)
         {
            this.applyClanList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ClanInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.applyClanList.push(_loc4_);
            _loc2_++;
         }
         this.foundCost = param1.readInt();
         this.foundCost = this.foundCost >>> 8 % 32 | this.foundCost << 32 - 8 % 32;
         this.companyDateInfoCommand = CompanyDateInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.companyDateInfoCommand)
         {
            this.companyDateInfoCommand.read(param1);
         }
         while(this.rejectApplyClanList.length > 0)
         {
            this.rejectApplyClanList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = param1.readInt();
            _loc5_ = _loc5_ >>> 16 % 32 | _loc5_ << 32 - 16 % 32;
            this.rejectApplyClanList.push(_loc5_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ClanInfoCommand = null;
         var _loc3_:int = 0;
         param1.writeShort(-13451);
         param1.writeByte(this.applyClanList.length);
         for each(_loc2_ in this.applyClanList)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.foundCost << 8 % 32 | this.foundCost >>> 32 - 8 % 32);
         if(null != this.companyDateInfoCommand)
         {
            this.companyDateInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.rejectApplyClanList.length);
         for each(_loc3_ in this.rejectApplyClanList)
         {
            param1.writeInt(_loc3_ << 16 % 32 | _loc3_ >>> 32 - 16 % 32);
         }
      }
   }
}

