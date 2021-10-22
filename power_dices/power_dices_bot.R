### Mi bot para Telegram
### Referencia completísima: https://ebeneditos.github.io/telegram.bot/
credentials = read.csv("../../../Credentials/credentials.txt")
bot_name = credentials$"bot_name"
my_token = credentials$"my_token"
my_id = credentials$"my_id"

library(telegram.bot)
bot <- Bot(token = my_token)
print(bot$getMe()) # Para ver si mis credenciales son correctos

## Inicio
updater <- Updater(token = my_token)

# Mensaje que se envía al recibir el comando /start.
start <- function(bot, update){
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = sprintf("Hola %s!\n- Prueba a usar /dn 6.", update$message$from$first_name))
}
start_handler <- CommandHandler("start", start)
updater <- updater + start_handler # Añadimos el inicio al listado de funcionalidades

# Esta función pasa a mayúsculas los argumentos adicionales
caps <- function(bot, update, args){
  if (length(args > 0L)){
    text_caps <- toupper(paste(args, collapse = " "))
    bot$sendMessage(chat_id = update$message$chat_id,
                    text = text_caps) 
  } else {
    bot$sendMessage(chat_id = update$message$chat_id,
                    text = sprintf("Esta función necesita argumentos, prueba con '/caps Hola'", update$message$from$first_name))
  }
}
updater <- updater + CommandHandler("caps", caps, pass_args = TRUE) # Añadimos la funcionalidad

# Esta función lanza un dado con args caras
dn <- function(bot, update, args){
  if (length(args > 0L)){
    args = as.integer(args)
    exit <- sample(x = 1:args, size = 1)
    bot$sendMessage(chat_id = update$message$chat_id,
                    text = paste0("Sacaste un ", exit, " con ese dado.")) 
  } else {
    bot$sendMessage(chat_id = update$message$chat_id,
                    text = sprintf("Esta función necesita argumentos, prueba con '/dn 6'", update$message$from$first_name))
  }
}
updater <- updater + CommandHandler("dn", dn, pass_args = TRUE) # Añadimos la funcionalidad

updater$start_polling()
