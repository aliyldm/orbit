package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MessageLocalizedWildcardCommand implements IModule
   {
      
      private static var _instance:MessageLocalizedWildcardCommand;
      
      public var baseKey:String = "";
      
      public var baseKeyType:ReplacementTypeModule;
      
      public var wildCardReplacements:Vector.<MessageWildcardReplacementModule>;
      
      public function MessageLocalizedWildcardCommand(param1:String = "", param2:ReplacementTypeModule = null, param3:Vector.<MessageWildcardReplacementModule> = null)
      {
         super();
         this.baseKey = param1;
         if(param2 == null)
         {
            this.baseKeyType = new ReplacementTypeModule();
         }
         else
         {
            this.baseKeyType = param2;
         }
         if(param3 == null)
         {
            this.wildCardReplacements = new Vector.<MessageWildcardReplacementModule>();
         }
         else
         {
            this.wildCardReplacements = param3;
         }
      }
      
      public static function get instance() : MessageLocalizedWildcardCommand
      {
         return _instance || (_instance = new MessageLocalizedWildcardCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 47;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:MessageWildcardReplacementModule = null;
         this.baseKey = param1.readUTF();
         this.baseKeyType = ReplacementTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.baseKeyType)
         {
            this.baseKeyType.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.wildCardReplacements.length > 0)
         {
            this.wildCardReplacements.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = MessageWildcardReplacementModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.wildCardReplacements.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:MessageWildcardReplacementModule = null;
         param1.writeShort(47);
         param1.writeUTF(this.baseKey);
         if(null != this.baseKeyType)
         {
            this.baseKeyType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.wildCardReplacements.length);
         for each(_loc2_ in this.wildCardReplacements)
         {
            _loc2_.write(param1);
         }
      }
   }
}

