package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class ClanAllInfoCommand implements IModule
   {
      
      private static var _instance:ClanAllInfoCommand;
      
      public var clanMemberInfoCommandList:Vector.<ClanMemberInfoCommand>;
      
      public var clanTaxInfoCommand:ClanTaxInfoCommand;
      
      public var clanDiploReqInfoCommands:Vector.<ClanDiploReqInfoCommand>;
      
      public var myClanDiploReqInfoCommands:Vector.<ClanDiploReqInfoCommand>;
      
      public var clanApplyInfoListCommand:ClanApplyInfoListCommand;
      
      public var clanMessageInfoCommands:Vector.<ClanMessageInfoCommand>;
      
      public var clanDiploInfoCommands:Vector.<ClanDiploInfoCommand>;
      
      public var clanRankInfoCommands:Vector.<ClanRankInfoCommand>;
      
      public var clanInfoCommand:ClanInfoCommand;
      
      public var clanNewsInfoCommands:Vector.<ClanNewsInfoCommand>;
      
      public var companyDateInfoCommand:CompanyDateInfoCommand;
      
      public function ClanAllInfoCommand(param1:ClanInfoCommand = null, param2:Vector.<ClanMemberInfoCommand> = null, param3:Vector.<ClanNewsInfoCommand> = null, param4:Vector.<ClanMessageInfoCommand> = null, param5:Vector.<ClanRankInfoCommand> = null, param6:Vector.<ClanDiploReqInfoCommand> = null, param7:Vector.<ClanDiploInfoCommand> = null, param8:CompanyDateInfoCommand = null, param9:ClanTaxInfoCommand = null, param10:ClanApplyInfoListCommand = null, param11:Vector.<ClanDiploReqInfoCommand> = null)
      {
         super();
         if(param2 == null)
         {
            this.clanMemberInfoCommandList = new Vector.<ClanMemberInfoCommand>();
         }
         else
         {
            this.clanMemberInfoCommandList = param2;
         }
         if(param9 == null)
         {
            this.clanTaxInfoCommand = new ClanTaxInfoCommand();
         }
         else
         {
            this.clanTaxInfoCommand = param9;
         }
         if(param6 == null)
         {
            this.clanDiploReqInfoCommands = new Vector.<ClanDiploReqInfoCommand>();
         }
         else
         {
            this.clanDiploReqInfoCommands = param6;
         }
         if(param11 == null)
         {
            this.myClanDiploReqInfoCommands = new Vector.<ClanDiploReqInfoCommand>();
         }
         else
         {
            this.myClanDiploReqInfoCommands = param11;
         }
         if(param10 == null)
         {
            this.clanApplyInfoListCommand = new ClanApplyInfoListCommand();
         }
         else
         {
            this.clanApplyInfoListCommand = param10;
         }
         if(param4 == null)
         {
            this.clanMessageInfoCommands = new Vector.<ClanMessageInfoCommand>();
         }
         else
         {
            this.clanMessageInfoCommands = param4;
         }
         if(param7 == null)
         {
            this.clanDiploInfoCommands = new Vector.<ClanDiploInfoCommand>();
         }
         else
         {
            this.clanDiploInfoCommands = param7;
         }
         if(param5 == null)
         {
            this.clanRankInfoCommands = new Vector.<ClanRankInfoCommand>();
         }
         else
         {
            this.clanRankInfoCommands = param5;
         }
         if(param1 == null)
         {
            this.clanInfoCommand = new ClanInfoCommand();
         }
         else
         {
            this.clanInfoCommand = param1;
         }
         if(param3 == null)
         {
            this.clanNewsInfoCommands = new Vector.<ClanNewsInfoCommand>();
         }
         else
         {
            this.clanNewsInfoCommands = param3;
         }
         if(param8 == null)
         {
            this.companyDateInfoCommand = new CompanyDateInfoCommand();
         }
         else
         {
            this.companyDateInfoCommand = param8;
         }
      }
      
      public static function get instance() : ClanAllInfoCommand
      {
         return _instance || (_instance = new ClanAllInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 30685;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 28;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ClanMemberInfoCommand = null;
         var _loc5_:ClanDiploReqInfoCommand = null;
         var _loc6_:ClanDiploReqInfoCommand = null;
         var _loc7_:ClanMessageInfoCommand = null;
         var _loc8_:ClanDiploInfoCommand = null;
         var _loc9_:ClanRankInfoCommand = null;
         var _loc10_:ClanNewsInfoCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.clanMemberInfoCommandList.length > 0)
         {
            this.clanMemberInfoCommandList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ClanMemberInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.clanMemberInfoCommandList.push(_loc4_);
            _loc2_++;
         }
         this.clanTaxInfoCommand = ClanTaxInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.clanTaxInfoCommand)
         {
            this.clanTaxInfoCommand.read(param1);
         }
         while(this.clanDiploReqInfoCommands.length > 0)
         {
            this.clanDiploReqInfoCommands.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = ClanDiploReqInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.clanDiploReqInfoCommands.push(_loc5_);
            _loc2_++;
         }
         while(this.myClanDiploReqInfoCommands.length > 0)
         {
            this.myClanDiploReqInfoCommands.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = ClanDiploReqInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.myClanDiploReqInfoCommands.push(_loc6_);
            _loc2_++;
         }
         this.clanApplyInfoListCommand = ClanApplyInfoListCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.clanApplyInfoListCommand)
         {
            this.clanApplyInfoListCommand.read(param1);
         }
         while(this.clanMessageInfoCommands.length > 0)
         {
            this.clanMessageInfoCommands.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc7_ = ClanMessageInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc7_.read(param1);
            this.clanMessageInfoCommands.push(_loc7_);
            _loc2_++;
         }
         while(this.clanDiploInfoCommands.length > 0)
         {
            this.clanDiploInfoCommands.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc8_ = ClanDiploInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc8_.read(param1);
            this.clanDiploInfoCommands.push(_loc8_);
            _loc2_++;
         }
         while(this.clanRankInfoCommands.length > 0)
         {
            this.clanRankInfoCommands.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc9_ = ClanRankInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc9_.read(param1);
            this.clanRankInfoCommands.push(_loc9_);
            _loc2_++;
         }
         this.clanInfoCommand = ClanInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.clanInfoCommand)
         {
            this.clanInfoCommand.read(param1);
         }
         while(this.clanNewsInfoCommands.length > 0)
         {
            this.clanNewsInfoCommands.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc10_ = ClanNewsInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc10_.read(param1);
            this.clanNewsInfoCommands.push(_loc10_);
            _loc2_++;
         }
         this.companyDateInfoCommand = CompanyDateInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.companyDateInfoCommand)
         {
            this.companyDateInfoCommand.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ClanMemberInfoCommand = null;
         var _loc3_:ClanDiploReqInfoCommand = null;
         var _loc4_:ClanDiploReqInfoCommand = null;
         var _loc5_:ClanMessageInfoCommand = null;
         var _loc6_:ClanDiploInfoCommand = null;
         var _loc7_:ClanRankInfoCommand = null;
         var _loc8_:ClanNewsInfoCommand = null;
         param1.writeShort(30685);
         param1.writeShort(this.clanMemberInfoCommandList.length);
         for each(_loc2_ in this.clanMemberInfoCommandList)
         {
            _loc2_.write(param1);
         }
         if(null != this.clanTaxInfoCommand)
         {
            this.clanTaxInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.clanDiploReqInfoCommands.length);
         for each(_loc3_ in this.clanDiploReqInfoCommands)
         {
            _loc3_.write(param1);
         }
         param1.writeShort(this.myClanDiploReqInfoCommands.length);
         for each(_loc4_ in this.myClanDiploReqInfoCommands)
         {
            _loc4_.write(param1);
         }
         if(null != this.clanApplyInfoListCommand)
         {
            this.clanApplyInfoListCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.clanMessageInfoCommands.length);
         for each(_loc5_ in this.clanMessageInfoCommands)
         {
            _loc5_.write(param1);
         }
         param1.writeShort(this.clanDiploInfoCommands.length);
         for each(_loc6_ in this.clanDiploInfoCommands)
         {
            _loc6_.write(param1);
         }
         param1.writeByte(this.clanRankInfoCommands.length);
         for each(_loc7_ in this.clanRankInfoCommands)
         {
            _loc7_.write(param1);
         }
         if(null != this.clanInfoCommand)
         {
            this.clanInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.clanNewsInfoCommands.length);
         for each(_loc8_ in this.clanNewsInfoCommands)
         {
            _loc8_.write(param1);
         }
         if(null != this.companyDateInfoCommand)
         {
            this.companyDateInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

