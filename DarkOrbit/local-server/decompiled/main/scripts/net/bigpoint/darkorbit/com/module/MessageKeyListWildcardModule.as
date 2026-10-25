package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MessageKeyListWildcardModule implements IModule
   {
      
      private static var _instance:MessageKeyListWildcardModule;
      
      public static const TEXTSTYLE_STANDARD:int = 0;
      
      public static const TEXTSTYLE_RED:int = 1;
      
      public static const TEXTSTYLE__MAX:int = 2;
      
      public var wildCardReplacements:Vector.<MessageWildcardReplacementModule>;
      
      public var baseKey:String = "";
      
      public var baseKeyType:ReplacementTypeModule;
      
      public var textStyle:int = 0;
      
      public function MessageKeyListWildcardModule(param1:int = 0, param2:String = "", param3:ReplacementTypeModule = null, param4:Vector.<MessageWildcardReplacementModule> = null)
      {
         super();
         if(param4 == null)
         {
            this.wildCardReplacements = new Vector.<MessageWildcardReplacementModule>();
         }
         else
         {
            this.wildCardReplacements = param4;
         }
         this.baseKey = param2;
         if(param3 == null)
         {
            this.baseKeyType = new ReplacementTypeModule();
         }
         else
         {
            this.baseKeyType = param3;
         }
         this.textStyle = param1;
      }
      
      public static function get instance() : MessageKeyListWildcardModule
      {
         return _instance || (_instance = new MessageKeyListWildcardModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -3325;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:MessageWildcardReplacementModule = null;
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
         this.baseKey = param1.readUTF();
         this.baseKeyType = ReplacementTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.baseKeyType)
         {
            this.baseKeyType.read(param1);
         }
         this.textStyle = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:MessageWildcardReplacementModule = null;
         param1.writeShort(-3325);
         param1.writeByte(this.wildCardReplacements.length);
         for each(_loc2_ in this.wildCardReplacements)
         {
            _loc2_.write(param1);
         }
         param1.writeUTF(this.baseKey);
         if(null != this.baseKeyType)
         {
            this.baseKeyType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.textStyle);
      }
   }
}

