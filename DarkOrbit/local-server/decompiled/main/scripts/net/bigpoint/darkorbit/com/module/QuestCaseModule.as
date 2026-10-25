package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestCaseModule implements IModule
   {
      
      private static var _instance:QuestCaseModule;
      
      public var id:int = 0;
      
      public var active:Boolean = false;
      
      public var mandatory:Boolean = false;
      
      public var ordered:Boolean = false;
      
      public var mandatoryCount:int = 0;
      
      public var modifier:Vector.<QuestElementModule>;
      
      public function QuestCaseModule(param1:int = 0, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:int = 0, param6:Vector.<QuestElementModule> = null)
      {
         super();
         this.id = param1;
         this.active = param2;
         this.mandatory = param3;
         this.ordered = param4;
         this.mandatoryCount = param5;
         if(param6 == null)
         {
            this.modifier = new Vector.<QuestElementModule>();
         }
         else
         {
            this.modifier = param6;
         }
      }
      
      public static function get instance() : QuestCaseModule
      {
         return _instance || (_instance = new QuestCaseModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2000;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 15;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:QuestElementModule = null;
         this.id = param1.readInt();
         this.id = this.id >>> 11 % 32 | this.id << 32 - 11 % 32;
         this.active = param1.readBoolean();
         this.mandatory = param1.readBoolean();
         this.ordered = param1.readBoolean();
         this.mandatoryCount = param1.readInt();
         this.mandatoryCount = this.mandatoryCount << 1 % 32 | this.mandatoryCount >>> 32 - 1 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.modifier.length > 0)
         {
            this.modifier.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = QuestElementModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.modifier.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:QuestElementModule = null;
         param1.writeShort(2000);
         param1.writeInt(this.id << 11 % 32 | this.id >>> 32 - 11 % 32);
         param1.writeBoolean(this.active);
         param1.writeBoolean(this.mandatory);
         param1.writeBoolean(this.ordered);
         param1.writeInt(this.mandatoryCount >>> 1 % 32 | this.mandatoryCount << 32 - 1 % 32);
         param1.writeByte(this.modifier.length);
         for each(_loc2_ in this.modifier)
         {
            _loc2_.write(param1);
         }
      }
   }
}

