use diesel::PgConnection;
use super::{SlackCommand, SlackResponse};
use ::services::{game_services, player_services};
use ::operations::{game_operations};

pub fn board(command: &SlackCommand, db: &PgConnection) -> Result<SlackResponse, String> {
    let game = game_services::get_by_channel_id(db, &command.channel_id)?;

    let players = player_services::get_players_from_game(db, &game);

    let text = format!("{}", game_operations::printing::format_game_state((&game, &players), true));

    Ok(SlackResponse::new(text, false))
}
