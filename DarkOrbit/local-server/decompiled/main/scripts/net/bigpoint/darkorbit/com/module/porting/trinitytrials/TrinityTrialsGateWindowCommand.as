package net.bigpoint.darkorbit.com.module.porting.trinitytrials
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.*;
   
   public class TrinityTrialsGateWindowCommand implements IModule
   {
      
      private static var _instance:TrinityTrialsGateWindowCommand;
      
      public var isFree:Boolean = false;
      
      public var curLootAmount:int = 0;
      
      public var lootId:String = "";
      
      public var attributeType:int = 0;
      
      public var openDifficulty:int = 0;
      
      public var openAttributes:Vector.<TupleTwoModule>;
      
      public function TrinityTrialsGateWindowCommand(param1:int = 0, param2:String = "", param3:int = 0, param4:Boolean = false, param5:int = 0, param6:Vector.<TupleTwoModule> = null)
      {
         super();
         this.isFree = param4;
         this.curLootAmount = param3;
         this.lootId = param2;
         this.attributeType = param1;
         this.openDifficulty = param5;
         if(param6 == null)
         {
            this.openAttributes = new Vector.<TupleTwoModule>();
         }
         else
         {
            this.openAttributes = param6;
         }
      }
      
      public static function get instance() : TrinityTrialsGateWindowCommand
      {
         return _instance || (_instance = new TrinityTrialsGateWindowCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 16953;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 19;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:TupleTwoModule = null;
         this.isFree = param1.readBoolean();
         this.curLootAmount = param1.readInt();
         this.curLootAmount = this.curLootAmount >>> 16 % 32 | this.curLootAmount << 32 - 16 % 32;
         this.lootId = param1.readUTF();
         this.attributeType = param1.readInt();
         this.attributeType = this.attributeType >>> 16 % 32 | this.attributeType << 32 - 16 % 32;
         this.openDifficulty = param1.readInt();
         this.openDifficulty = this.openDifficulty >>> 13 % 32 | this.openDifficulty << 32 - 13 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.openAttributes.length > 0)
         {
            this.openAttributes.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = TupleTwoModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.openAttributes.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:TupleTwoModule = null;
         param1.writeShort(16953);
         param1.writeBoolean(this.isFree);
         param1.writeInt(this.curLootAmount << 16 % 32 | this.curLootAmount >>> 32 - 16 % 32);
         param1.writeUTF(this.lootId);
         param1.writeInt(this.attributeType << 16 % 32 | this.attributeType >>> 32 - 16 % 32);
         param1.writeInt(this.openDifficulty << 13 % 32 | this.openDifficulty >>> 32 - 13 % 32);
         param1.writeByte(this.openAttributes.length);
         for each(_loc2_ in this.openAttributes)
         {
            _loc2_.write(param1);
         }
      }
   }
}

